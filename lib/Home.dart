import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart'as http;
class Home extends StatefulWidget {
  const Home({super.key});  

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.amberAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(onPressed: (){
               makePayment();
            }, child: const Text('Pay')),
          )
        ],
      ),
    );
  }


  Future<void> makePayment() async {
    try {
      paymentIntentData =
      await createPaymentIntent('2000', 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              setupIntentClientSecret: 'your secret key',
              paymentIntentClientSecret:paymentIntentData!['client_secret'],
              //applePay: PaymentSheetApplePay.,
              //googlePay: true,
              //testEnv: true,
              customFlow: true,
              style: ThemeMode.dark,
              // merchantCountryCode: 'US',
              merchantDisplayName: 'name'))
          .then((value) {
            if (kDebugMode) {
              print('Payment intent ==========$paymentIntentData');
            }
      });

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      if (kDebugMode) {
        print('Payment exception:$e$s');
      }
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
        //       parameters: PresentPaymentSheetParameters(
        // clientSecret: paymentIntentData!['client_secret'],
        // confirmPayment: true,
        // )
      ).then((newValue) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        }
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('Exception/DISPLAYPAYMENTSHEET==> $e');
      }
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      if (kDebugMode) {
        print(body);
      }
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ' + 'your key ',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent response ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (error) {
      if (kDebugMode) {
        print('error charging user: ${error.toString()}');
      }
    }
  }

}
