import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_pay_with_stripe/stripe_const.dart';
import 'package:pay/pay.dart' as pay;
import 'package:http/http.dart' as http;

class StripeGPay extends StatefulWidget {
  const StripeGPay({super.key, required this.amount});

  final int amount;

  @override
  State<StripeGPay> createState() => _StripeGPayState();
}

class _StripeGPayState extends State<StripeGPay> {
  showSnackBar(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> onGooglePayResult(paymentResult) async {
    try {
      final response = await fetchPaymentIntentClientSecret();

      if (response["error"] != null) {
        showSnackBar(response["error"]["message"] ?? "error");
      } else {
        final clientSecret = response['client_secret'];
        final token =
            paymentResult['paymentMethodData']['tokenizationData']['token'];
        final tokenJson = Map.castFrom(json.decode(token));

        final params = PaymentMethodParams.cardFromToken(
          paymentMethodData: PaymentMethodDataCardFromToken(
            token: tokenJson['id'], // TODO extract the actual token
          ),
        );

        await Stripe.instance
            .confirmPayment(
          paymentIntentClientSecret: clientSecret,
          data: params,
        )
            .whenComplete(() {
          sendToConnectedAccount();
        });
      }
    } catch (e) {
      showSnackBar(e.toString);
    }
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    try {
      Map<String, dynamic> body = {
        'amount': (widget.amount * 1).ceil().toString(),
        'currency': "usd",
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      showSnackBar(err.toString);
      return {"error": "error"};
    }
  }

  sendToConnectedAccount() async {
    try {
      Map<String, dynamic> body = {
        'amount': (widget.amount * 0.8).ceil().toString(),
        'currency': "usd",
        'destination': 'acct_1LxWBvRbSrPpo7Uf',
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/transfers'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51Kq1flDoMa06ywt0jnZDm0ynDAMEamd8KfXVj32cyC2D1XiXx8S9HVeGNpFZvagbjp2hfsnQ8MscnMJxC4L7qj1M00DMbixKyI',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      final res = jsonDecode(response.body.toString());

      if (res["error"] != null) {
        showSnackBar(res["error"]["message"] ?? "error");
      } else {
        showSnackBar("Success");
      }
      // return jsonDecode(response.body);
    } catch (e) {
      showSnackBar(e.toString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe GPay"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            pay.GooglePayButton(
              paymentConfigurationAsset: 'stripe_google_pay_payment.json',
              paymentItems: paymentItems,
              type: pay.GooglePayButtonType.pay,
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
