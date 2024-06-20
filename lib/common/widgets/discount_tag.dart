import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountTag extends StatelessWidget {
  final double? discount;
  final String? discountType;
  final double fromTop;
  final double? fontSize;
  final bool inLeft;
  final bool? freeDelivery;
  final bool? isFloating;
  const DiscountTag({
    super.key,
    required this.discount,
    required this.discountType,
    this.fromTop = 10,
    this.fontSize,
    this.freeDelivery = false,
    this.inLeft = true,
    this.isFloating = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isRightSide =
        Get.find<SplashController>().configModel!.currencySymbolDirection ==
            'right';
    String currencySymbol =
        Get.find<SplashController>().configModel!.currencySymbol!;

    return (discount! > 0 || freeDelivery!)
        ? Positioned(
            top: fromTop,
            left: inLeft
                ? isFloating!
                    ? Dimensions.paddingSizeSmall
                    : 0
                : null,
            right: inLeft ? null : 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(10)
                ),
              ),
              child: Text(
                discount! > 0
                    ? '${(isRightSide || discountType == 'percent') ? '' : currencySymbol}$discount${discountType == 'percent' ? '%' : isRightSide ? currencySymbol : ''} ${'off'.tr}'
                    : 'free_delivery'.tr,
                style: robotoMedium.copyWith(
  
                  color: Theme.of(context).cardColor,
                  fontSize:
                      12 ?? (ResponsiveHelper.isMobile(context) ? 8 : 12),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : const SizedBox();
  }
}
