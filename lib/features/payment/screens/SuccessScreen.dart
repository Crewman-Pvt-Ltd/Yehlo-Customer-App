import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:yehlo_User/helper/route_helper.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/LottieAssets/Success1.json'),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Thank you for your purchase.',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 20),
              const Text(
                'Redirecting To Sign in Screen......',
                style: TextStyle(fontSize: 13),
              ),
              // Text('Seller: $sellerName'),
              // Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
              //const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Get.offAllNamed(RouteHelper.getSignInRoute());
              //     // Navigator.push(
              //     //     context,
              //     //     MaterialPageRoute(
              //     //       builder: (context) => const Dashboard(),
              //     //     ));
              //   },
              //   child: const Text('Proceed For Listing Your Items.'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
