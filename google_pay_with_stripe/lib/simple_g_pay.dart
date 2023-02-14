import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_pay_with_stripe/stripe_const.dart';
import 'package:pay/pay.dart';

class SimpleGPay extends StatefulWidget {
  const SimpleGPay({super.key ,required this.amount});


 final int amount;

  @override
  State<SimpleGPay> createState() => _SimpleGPayState();
}

class _SimpleGPayState extends State<SimpleGPay> {

  void onGooglePayResult(paymentResult) {

    if (kDebugMode) {
      print(paymentResult);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple GPay"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            GooglePayButton(
              paymentConfigurationAsset: 'g_pay_payment_profile.json',
              paymentItems: paymentItems,
              type: GooglePayButtonType.pay,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: onGooglePayResult,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
