import 'package:flutter/material.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';

class GooglePay extends StatefulWidget {
  const GooglePay({super.key});

  @override
  State<GooglePay> createState() => _GooglePayState();
}

class _GooglePayState extends State<GooglePay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Google Pay",
          style: AppWidgets.boldTextFieldStyle(),
        ),
      ),
    );
  }
}
