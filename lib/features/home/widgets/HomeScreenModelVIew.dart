import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:yehlo_User/common/widgets/address_widget.dart';
import 'package:yehlo_User/common/widgets/custom_ink_well.dart';
import 'package:yehlo_User/features/banner/controllers/banner_controller.dart';
import 'package:yehlo_User/features/location/controllers/location_controller.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/features/address/controllers/address_controller.dart';
import 'package:yehlo_User/features/address/domain/models/address_model.dart';
import 'package:yehlo_User/helper/address_helper.dart';
import 'package:yehlo_User/helper/auth_helper.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/styles.dart';
import 'package:yehlo_User/common/widgets/custom_image.dart';
import 'package:yehlo_User/common/widgets/custom_loader.dart';
import 'package:yehlo_User/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yehlo_User/features/home/widgets/banner_view.dart';
import 'package:yehlo_User/features/home/widgets/popular_store_view.dart';

class HomeScreenModuleView extends StatelessWidget {
  final SplashController splashController;
  const HomeScreenModuleView({super.key, required this.splashController});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GetBuilder<BannerController>(builder: (bannerController) {
        return const BannerView(isFeatured: true);
      }),
      splashController.moduleList != null
          ? splashController.moduleList!.isNotEmpty
              ? SizedBox(
                  height: 150, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount: splashController.moduleList!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 90, // Increased width for a higher aspect ratio
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        child: CustomInkWell(
                          onTap: () => splashController.switchModule(index, true),
                          radius: Dimensions.radiusDefault,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImage(
                                  image: '${splashController.configModel!.baseUrls!.moduleImageUrl}/${splashController.moduleList![index].icon}',
                                  height: 68, // Increased image height
                                  width: 68,  // Increased image width
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              Text(
                                splashController.moduleList![index].moduleName!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault), // Increased text size
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    child: Text('no_module_found'.tr),
                  ),
                )
          : ModuleShimmer(isEnabled: splashController.moduleList == null),
    ]);
  }
}

class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;
  const ModuleShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            width: 150, // Increased width for a higher aspect ratio
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[Get.isDarkMode ? 700 : 200]!,
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: isEnabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100, // Increased shimmer height
                    width: 100,  // Increased shimmer width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(
                    height: 20,
                    width: 70,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
