import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:yehlo_User/features/banner/controllers/banner_controller.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/common/widgets/custom_image.dart';

class PromotionalBannerView extends StatelessWidget {
  const PromotionalBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      return bannerController.promotionalBanner != null
          ? bannerController.promotionalBanner!.bottomSectionBanner != null
              ? Container(
                  height: 130,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomImage(
                      image: '${bannerController.promotionalBanner!.promotionalBannerUrl}/${bannerController.promotionalBanner!.bottomSectionBanner}',
                      fit: BoxFit.cover,
                      height: 140,
                      width: double.infinity,
                    ),
                  ),
                )
              : const SizedBox()
          : const PromotionalBannerShimmerView();
    });
  }
}

class PromotionalBannerShimmerView extends StatelessWidget {
  const PromotionalBannerShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
      ),
    );
  }
}
