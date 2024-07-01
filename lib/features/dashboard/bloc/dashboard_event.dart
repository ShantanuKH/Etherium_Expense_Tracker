part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class DashboardInitialFetchEvent extends DashboardEvent {}

class DashboardDepositeEvent extends DashboardEvent {
  final TransactionModel transactionModel;

  DashboardDepositeEvent({required this.transactionModel});
}


class DashboardWithdrawEvent extends DashboardEvent {
  final TransactionModel transactionModel;

  DashboardWithdrawEvent({required this.transactionModel});

 
}
