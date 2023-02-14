import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_pay_with_stripe/stripe_const.dart';
import 'package:google_pay_with_stripe/stripe_g_pay.dart';

import 'simple_g_pay.dart';
// import 'strip_const.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublicKey;
  Stripe.merchantIdentifier = merchantIdentifier;
  Stripe.urlScheme = urlScheme;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SelectScreen(),
    );
  }
}

class SelectScreen extends StatelessWidget {
  SelectScreen({Key? key}) : super(key: key);

  final TextEditingController amount = TextEditingController();

  int getAmount() {
    return ((int.tryParse(amount.text.trim()) ?? 10) * 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                controller: amount,
                decoration: const InputDecoration(
                  hintText: "10.00",
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SimpleGPay(amount: getAmount())));
              },
              child: const Text("Simple GPay"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StripeGPay(amount: getAmount())));
              },
              child: const Text("Stripe GPay"),
            ),
          ],
        ),
      ),
    );
  }
}
