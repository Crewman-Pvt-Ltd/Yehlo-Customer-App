import 'package:flutter/material.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/images.dart';
import 'package:yehlo_User/common/widgets/custom_image.dart';

class WebStoreWiseBannerViewWidget extends StatelessWidget {
  const WebStoreWiseBannerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
      child: Container(
        height: 135, width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          child: const CustomImage(
            image: Images.placeholder,
            fit: BoxFit.cover, height: 135, width: double.infinity,
          ),
        ),
      ),
    );
  }
}
