import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:yehlo_User/common/widgets/custom_image.dart';
import 'package:yehlo_User/common/widgets/title_widget.dart';
import 'package:yehlo_User/features/category/controllers/category_controller.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/helper/route_helper.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/styles.dart';

class CategoryPopUp extends StatelessWidget {
  final CategoryController categoryController;
  const CategoryPopUp({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Center(
            child: Text(
          'All Categories',
          style: TextStyle(color: Colors.white),
        )),
        actions: const [
          SizedBox(
            width: 50,
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.2,
          width: 500,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
              //   child: TitleWidget(title: 'categories'.tr),
              // ),
              Expanded(
                child: SizedBox(
                  height: 80,
                  child: categoryController.categoryList != null
                         ? GridView.builder(
                          itemCount: categoryController.categoryList!.length,
                          padding: const EdgeInsets.only(
                          left: Dimensions.paddingSizeSmall),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 20,
                            crossAxisCount: GetPlatform.isDesktop ? 5 : 4,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              child: InkWell(
                                onTap: () => Get.toNamed(
                                    RouteHelper.getCategoryItemRoute(
                                  categoryController.categoryList![index].id,
                                  categoryController.categoryList![index].name!,
                                )),
                                child: SizedBox(
                                  width: 70, // Increased width
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 70, // Increased height
                                        width: 70, // Increased width
                                        margin: const EdgeInsets.only(
                                            bottom: Dimensions
                                                .paddingSizeExtraSmall),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[
                                                    Get.isDarkMode
                                                        ? 800
                                                        : 200]!,
                                                blurRadius: 5,
                                                spreadRadius: 1)
                                          ],
                                        ),
                                        child: CustomImage(
                                          image:
                                              '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                          height: 70, // Increased height
                                          width: 70, // Increased width
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Text(
                                        categoryController
                                            .categoryList![index].name!,
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : CategoryShimmer(categoryController: categoryController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const CategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: categoryController.categoryList == null,
              child: Column(children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 5),
                Container(height: 10, width: 50, color: Colors.grey[300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}
