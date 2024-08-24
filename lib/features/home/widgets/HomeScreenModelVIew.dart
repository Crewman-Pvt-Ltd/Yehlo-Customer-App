import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:yehlo_User/common/widgets/custom_ink_well.dart';
import 'package:yehlo_User/features/banner/controllers/banner_controller.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/styles.dart';
import 'package:yehlo_User/common/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yehlo_User/features/home/widgets/banner_view.dart';

class HomeScreenModuleView extends StatefulWidget {
  final SplashController splashController;
  const HomeScreenModuleView({super.key, required this.splashController});

  @override
  _HomeScreenModuleViewState createState() => _HomeScreenModuleViewState();
}

class _HomeScreenModuleViewState extends State<HomeScreenModuleView> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GetBuilder<BannerController>(builder: (bannerController) {
        return const BannerView(isFeatured: true);
      }),
      widget.splashController.moduleList != null
          ? widget.splashController.moduleList!.isNotEmpty
              ? SizedBox(
                  height: 120, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount: widget.splashController.moduleList!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 84, // Increased width for a higher aspect ratio
                        margin: const EdgeInsets.only(
                            right: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusDefault),
                          color: selectedIndex == index
                              ? Color(0xFF44287d) // Highlight selected module
                              : Theme.of(context).cardColor,
                          border: selectedIndex == index
                              ? null // No border when selected
                              : Border.all(
                                  
                                  color: Colors
                                      .grey.shade300, // Set the border color when unselected
                                  width: 1.0, // Set the border width
                                ),
                        ),
                        child: CustomInkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            widget.splashController.switchModule(index, true);
                          },
                          radius: Dimensions.radiusDefault,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                child: CustomImage(
                                  image:
                                      '${widget.splashController.configModel!.baseUrls!.moduleImageUrl}/${widget.splashController.moduleList![index].icon}',
                                  height: 50, // Increased image height
                                  width: 50, // Increased image width
                                ),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Text(
                                widget.splashController.moduleList![index]
                                    .moduleName!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: robotoMedium.copyWith(
                                  fontSize: 12, // Increased text size
                                  color: selectedIndex == index
                                      ? Colors
                                          .white // Set text color to white when selected
                                      : Colors.black, // Default text color
                                ),
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
                    padding:
                        const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    child: Text('no_module_found'.tr),
                  ),
                )
          : ModuleShimmer(
              isEnabled: widget.splashController.moduleList == null),
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
                    width: 100, // Increased shimmer width
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
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
