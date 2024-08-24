import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PayementFailedScreen extends StatelessWidget {
  const PayementFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/Lottie/PaymentFailed.json'),
    );
  }
}
