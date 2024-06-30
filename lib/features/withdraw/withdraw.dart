import 'package:etherium_expense_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
 final TextEditingController addresscontroller = TextEditingController();
    final TextEditingController amountcontroller = TextEditingController();
      final TextEditingController reasoncontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 221, 221),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Withdraw details",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30),
          ),
        ),
       backgroundColor: Color.fromARGB(255, 255, 190, 190),),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              controller: addresscontroller,
              decoration: InputDecoration(
                hintText: "Enter the Address",
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: amountcontroller,
              decoration: InputDecoration(
                hintText: "Enter the Amount",
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: reasoncontroller,
              decoration: InputDecoration(
                hintText: "Enter the Reason",
              ),
            ),
            const SizedBox(height: 80),
            Container(
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
                color: AppColors.redaccent,
              ),
              child: Center(
                  child: Text(
                "Withdraw",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
