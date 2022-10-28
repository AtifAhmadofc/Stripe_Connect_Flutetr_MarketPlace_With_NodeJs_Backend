import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_connect/pages/checkout.dart';
import 'package:flutter_stripe_connect/pages/qrScaner.dart';
import 'package:flutter_stripe_connect/services/stripe-backend-service.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../app-state.dart';

class PayOut extends StatefulWidget {
  @override
  _PayOutState createState() => _PayOutState();
}

class Product {
  String title;
  double price;
  String currency;
  Image image;

  displayCurrency() {
    switch (this.currency) {
      case 'eur':
        return '€';
      case 'usd':
        return '\$';
      default:
        return '\$';
    }
  }

  Product(
      {required this.title,
      required this.price,
      required this.currency,
      required this.image});
}

class _PayOutState extends State<PayOut> {
  List<Product> products = [
    new Product(
        title: 'Beats X',
        price: 100,
        currency: 'usd',
        image: Image(image: AssetImage('assets/beats-x.png'))),
    new Product(
        title: 'Arctis Pro Wireless',
        price: 200,
        currency: 'usd',
        image: Image(image: AssetImage('assets/arctis-pro-wireless.png')))
  ];

  Future<void> _showMyDialog(int productId) async {
    Barcode? result;
    QRViewController? controller;
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[

            TextButton(onPressed: () async {

              String? code=await Navigator.push(context, MaterialPageRoute(builder: (context)=>QRViewExample()));

              if(code!=null){
                getPaid(code,productId);
              }

            }, child: Text("ads")),
          ],
        );
      },
    );
  }


  getPaid(String accountId, int id) async {
    try {
      CheckoutSessionResponse response = await StripeBackendService.payForProduct(products[id], accountId);
      String sessionId = response.session['id'];
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CheckoutPage(sessionId: sessionId),
        ))
            .then((value) {
          if (value == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
                new SnackBar(
                  content: Text('Payment Successful'),
                  backgroundColor: Colors.green,
                )
            );
          } else if (value == 'cancel') {
            ScaffoldMessenger.of(context).showSnackBar(
                new SnackBar(
                  content: Text('Payment Failed or Cancelled'),
                  backgroundColor: Colors.red
                )
            );
          }
        });
      });
    } catch (e) {
      log(e.toString());

    }
  }


  List<InkWell> _buildCard(int count) => List.generate(count, (i) {
        final appState = Provider.of<AppState>(context, listen: false);
        String accountId = appState.accountId;
        return InkWell(
            child: Card(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text(products[i].title),
              subtitle: Text(products[i].price.toString() +
                  ' ' +
                  products[i].displayCurrency()),
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              child: products[i].image,
            ),
            ButtonBar(
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).accentColor
                  )),
                  child: const Text('Pay with Stripe'),
                  onPressed: () async {
                    // ProgressDialog pd = ProgressDialog(context: context);
                    // pd.show(
                    //   max: 100,
                    //   msg: 'Please wait...',
                    //   progressBgColor: Colors.transparent,
                    // );
                    _showMyDialog(i);



                  },
                ),
              ],
            )
          ],
        )));
      });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    String accountId = appState.accountId;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay as Customer"),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: accountId != ''
          ? Container(
              padding: EdgeInsets.all(30),
              child: ListView(
                children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text('Seller Account ID = ' + accountId)),
                  ..._buildCard(2)
                ],
              ),
            )
          : Center(
              child: Text('Please register as a seller first'),
            ),
    );
  }
}
