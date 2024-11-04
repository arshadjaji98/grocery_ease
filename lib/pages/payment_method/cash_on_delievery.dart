import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class CashOnDelievery extends StatefulWidget {
  const CashOnDelievery({super.key});

  @override
  State<CashOnDelievery> createState() => _CashOnDelieveryState();
}

class _CashOnDelieveryState extends State<CashOnDelievery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cash on delivery",
          style: AppWidgets.boldTextFieldStyle(),
        ),
      ),
    );
  }
}
