import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:etherium_expense_tracker/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:etherium_expense_tracker/features/deposit/deposit.dart';
import 'package:etherium_expense_tracker/features/withdraw/withdraw.dart';
import 'package:etherium_expense_tracker/utils/colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardBloc dashboardBloc = DashboardBloc();

  @override
  void initState() {
    dashboardBloc.add(DashboardInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Web3 Bank",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 99, 99, 180),
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: dashboardBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DashboardLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DashboardErrorState) {
            return Center(
              child: Text("Error"),
            );
          } else if (state is DashboardSuccessState) {
            final successState = state as DashboardSuccessState;
            return Container(
              
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                children: [
                  Material(
                    elevation: 5,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/Ethereum.svg",
                              height: 45,
                              width: 50,
                            ),
                            SizedBox(width: 10),
                            Text(
                              successState.balance.toString()+" ETH",
                              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WithdrawPage(dashboardBloc: dashboardBloc,)),
                          ),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.redaccent,
                            ),
                            child: Center(
                              child: Text(
                                "- Debit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DepositePage(
                              dashboardBloc: dashboardBloc,
                            )),
                          ),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.greenaccent,
                            ),
                            child: Center(
                              child: Text(
                                "+ Credit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Transactions",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder
                    (
                      itemCount: successState.transactions.length,
                      itemBuilder: (context, index){
                         Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white60,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/Ethereum.svg",
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    successState.transactions[index].amount.toString()+" ETH",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                successState.transactions[index].address,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                successState.transactions[index].reasons,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        );
                        
                      } ,
                     
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}





// import 'package:etherium_expense_tracker/features/dashboard/bloc/dashboard_bloc.dart';
// import 'package:etherium_expense_tracker/features/deposit/deposit.dart';
// import 'package:etherium_expense_tracker/features/withdraw/withdraw.dart';
// import 'package:etherium_expense_tracker/utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   final DashboardBloc dashboardBloc = DashboardBloc();
//   @override
//   void initState() {
//     dashboardBloc.add(DashboardInitialFetchEvent());
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.accent,
//       appBar: AppBar(
//         title: Center(
//           child: Text(
//             "Web3 Bank",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 99, 99, 180),
//       ),
//       body: Container(
//         margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         child: Column(
//           children: [
//             Material(
//               elevation: 5,
//               child: Center(
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     // borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(
//                         "assets/Ethereum.svg",
//                         height: 45,
//                         width: 50,
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         "10 ETH",
//                         style: TextStyle(
//                             fontSize: 45, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WithdrawPage())),
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.3),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: Offset(0, 3), // changes position of shadow
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(10),
//                         color: AppColors.redaccent,
//                       ),
//                       child: Center(
//                           child: Text(
//                         "- Debit",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 30,
//                             fontWeight: FontWeight.w500),
//                       )),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => DepositePage())),
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.3),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(10),
//                         color: AppColors.greenaccent,
//                       ),
//                       child: Center(
//                           child: Text(
//                         "+ Credit",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 30,
//                             fontWeight: FontWeight.w500),
//                       )),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Text(
//               "Transactions",
//               style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Expanded(
//                 child: ListView(
//               children: [
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: Colors.white60),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           SvgPicture.asset(
//                             "assets/Ethereum.svg",
//                             height: 25,
//                             width: 25,
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             "1 ETH",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           )
//                         ],
//                       ),
//                       Text(
//                         "0x35642b8C280c464DB48D90d9f7E4d5C625F9EB30",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       Text(
//                         "NFT Purchase",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 17,
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }
