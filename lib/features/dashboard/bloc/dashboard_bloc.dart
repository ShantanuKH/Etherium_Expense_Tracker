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
          "0x4ccda1c0988df882136449cb9c60d4b47bad22544504f3f5d6978136f94b9c9f";

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
          EthereumAddress.fromHex("0xfa65C75672a4ee55F7878168944E91D0f564A37C");

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
        EthereumAddress.fromHex("0xfa65C75672a4ee55F7878168944E91D0f564A37C")
      ]);
      List<TransactionModel> trans = [];
      for (int i = 0; i < transactionsData[0].length; i++) {
        TransactionModel transactionModel = TransactionModel(
            transactionsData[0][i].toString(),
            transactionsData[1][i].toInt(),
            transactionsData[2][i],
            DateTime.fromMicrosecondsSinceEpoch(
                transactionsData[3][i].toInt()));
        trans.add(transactionModel);
      }

      transactions = trans;
      int bal = balanceData[0].toInt();
      balance = bal;

      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e) {
      print(e.toString());
      emit(DashboardErrorState());
    }
  }

  FutureOr<void> dashBoardDepositeEvent(
      DashboardDepositeEvent event, Emitter<DashboardState> emit) async {
    try {
      final transaction = Transaction.callContract(
          contract: _deployedContract,
          function: _deposit,
          parameters: [
            BigInt.from(event.transactionModel.amount),
            event.transactionModel.reasons
          ],
          value: EtherAmount.inWei(BigInt.from(event.transactionModel.amount)));

      final result = await _web3Client!.sendTransaction(_creds, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      // log(e.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      // log(e.toString());
    }
  }

  FutureOr<void> dashboardWithdrawEvent(
      DashboardWithdrawEvent event, Emitter<DashboardState> emit) async {
    try {
      final transaction = Transaction.callContract(
        contract: _deployedContract,
        function: _withdraw,
        parameters: [
          BigInt.from(event.transactionModel.amount),
          event.transactionModel.reasons
        ],
      );

      final result = await _web3Client!.sendTransaction(_creds, transaction,
          chainId: 1337, fetchChainIdFromNetworkId: false);
      // log(e.toString());
      add(DashboardInitialFetchEvent());
    } catch (e) {
      // log(e.toString());
    }
  }
}
