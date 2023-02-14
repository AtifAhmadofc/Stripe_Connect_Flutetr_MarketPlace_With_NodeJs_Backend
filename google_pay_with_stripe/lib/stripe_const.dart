import 'package:pay/pay.dart';

const  List<PaymentItem> paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '0.99',
    status: PaymentItemStatus.final_price,
  )
];

String stripeSecretKey="sk_test_51Kq1flDoMa06ywt0jnZDm0ynDAMEamd8KfXVj32cyC2D1XiXx8S9HVeGNpFZvagbjp2hfsnQ8MscnMJxC4L7qj1M00DMbixKyI";
String stripePublicKey="pk_test_51Kq1flDoMa06ywt0dBpBSXdUGtGXy1to7FEDfEQY9ApFb6DF58xVwe3Jj5WwURoJWn6ahbDi6wmhorVmcg0fOPWH0005J8RvzO";
String merchantIdentifier='merchant.flutter.stripe.test';
String urlScheme="flutterstripe";