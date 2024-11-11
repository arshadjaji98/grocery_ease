import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryease_delivery_application/widgets/widget_support.dart';
import 'package:pay/pay.dart';

class GooglePay extends StatefulWidget {
  final String total;
  const GooglePay({super.key, required this.total});

  @override
  State<GooglePay> createState() => _GooglePayState();
}

class _GooglePayState extends State<GooglePay> {
  late List<PaymentItem> _paymentItems;
  PaymentConfiguration? _paymentConfiguration;

  @override
  void initState() {
    super.initState();
    _initializePaymentItems();
    _loadPaymentConfiguration();
  }

  void _initializePaymentItems() {
    _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: widget.total,
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  Future<void> _loadPaymentConfiguration() async {
    final configString = await rootBundle.loadString('assets/gpay.json');
    setState(() {
      _paymentConfiguration = PaymentConfiguration.fromJsonString(configString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Google Pay", style: AppWidgets.boldTextFieldStyle()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_paymentConfiguration != null)
              GooglePayButton(
                paymentConfiguration: _paymentConfiguration!,
                paymentItems: _paymentItems,
                type: GooglePayButtonType.pay,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (data) {
                  print(data);
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
