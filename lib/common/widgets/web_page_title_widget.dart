import 'package:flutter/material.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/util/styles.dart';

class WebScreenTitleWidget extends StatelessWidget {
  final String title;
  const WebScreenTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? Container(
      height: 64,
      color: Theme.of(context).primaryColor.withOpacity(0.10),
      child: Center(child: Text(title, style: robotoMedium)),
    ) : const SizedBox();
  }
}
