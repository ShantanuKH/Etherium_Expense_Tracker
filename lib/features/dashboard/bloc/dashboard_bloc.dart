import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:etherium_expense_tracker/models/transaction_model.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {
      on<DashboardInitialFetchEvent>(dashboardInitialFetchEvent);
    });
    on<DashboardDepositeEvent>(dashBoardDepositeEvent);

    on<DashboardWithdrawEvent>(dashboardWithdrawEvent);
  }

  List<TransactionModel> transactions = [];
  Web3Client? _web3Client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  int balance = 0;

  // Functions
  late DeployedContract _deployedContract;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  FutureOr<void> dashboardInitialFetchEvent(
      DashboardInitialFetchEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoadingState());

    try {
      // rpcUrl means where the Ganache is running
      const String rpcUrl = "http://127.0.0.1:7545";
      // To create socketUrl we just copy the same and place websocket(ws) in place of https
      const String socketUrl = "ws://127.0.0.1:7545";
      const String privateKey =
          "0x530564352ea30368b2180c783a4365c5a082cae8a27b7c168510684d8857913a";

// Using this web3 client we can communicate to the SmartContract
      _web3Client = Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(socketUrl).cast<String>();
        },
      );

      // to get the ABI (Application Binary interface) file , Which is created in the build/contracts/ExpenseManagerContract.json file
      String abiFile = await rootBundle
          .loadString('build/contracts/ExpenseManagerContract.json');

      // To decode the json file say

      var jsonDecoded = jsonDecode(abiFile);
      _abiCode = ContractAbi.fromJson(
          jsonEncode(jsonDecoded['abi']), 'ExpenseManagerContract');

      _contractAddress =
          EthereumAddress.fromHex("0x9DF9fb8D87c280766a002f4A329C2D1d94e3de86");

      _creds = EthPrivateKey.fromHex(privateKey);

      // Get the deployed Contract
      _deployedContract = DeployedContract(_abiCode, _contractAddress);

      _deposit = _deployedContract.function("deposite");
      _withdraw = _deployedContract.function("withdraw");
      _getBalance = _deployedContract.function("getBalance");
      _getAllTransactions = _deployedContract.function("getAllTransaction");

      // Call the function for fetching the transactions

      final transactionsData = await _web3Client!.call(
          contract: _deployedContract,
          function: _getAllTransactions,
          params: []);

      final balanceData = await _web3Client!
          .call(contract: _deployedContract, function: _getBalance, params: [
        EthereumAddress.fromHex("0x9DF9fb8D87c280766a002f4A329C2D1d94e3de86")
      ]);
      List<TransactionModel> trans = [];
      for (int i = 0; i < transactionsData[0].length; i++) {
        TransactionModel transactionModel = TransactionModel(
            transactionsData[0][i],
            transactionsData[1][i],
            transactionsData[2][i],
            DateTime.fromMicrosecondsSinceEpoch(transactionsData[3][i])
            );
      }
      ;
    } catch (e) {
      print(e.toString());
      emit(DashboardErrorState());
    }
  }

  FutureOr<void> dashBoardDepositeEvent(
      DashboardDepositeEvent event, Emitter<DashboardState> emit) async {
    final data = await _web3Client!.call(
        contract: _deployedContract,
        function: _deposit,
        params: [
          event.transactionModel.amount,
          event.transactionModel.reasons
        ]);
    print(data.toString());
  }

  FutureOr<void> dashboardWithdrawEvent(
      DashboardWithdrawEvent event, Emitter<DashboardState> emit) async {
    final data = await _web3Client!.call(
        contract: _deployedContract,
        function: _withdraw,
        params: [
          event.transactionModel.amount,
          event.transactionModel.reasons
        ]);
    print(data.toString());
  }
}
