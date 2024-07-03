import 'package:yehlo_User/features/category/controllers/category_controller.dart';
import 'package:yehlo_User/features/language/controllers/language_controller.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/helper/route_helper.dart';
import 'package:yehlo_User/util/app_constants.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/styles.dart';
import 'package:yehlo_User/common/widgets/custom_image.dart';
import 'package:yehlo_User/features/home/widgets/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<SplashController>(builder: (splashController) {
      bool isPharmacy = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.pharmacy;
      bool isFood = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.food;

      return GetBuilder<CategoryController>(builder: (categoryController) {
        return (categoryController.categoryList != null &&
                categoryController.categoryList!.isEmpty)
            ? const SizedBox()
            : isPharmacy
                ? PharmacyCategoryView(categoryController: categoryController)
                : isFood
                    ? FoodCategoryView(categoryController: categoryController)
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              left: 15,
                              right: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Explore By Categories',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CategoryPopUp(
                                                  categoryController:
                                                      categoryController,
                                                )));
                                  },
                                  child: const Text('See All>',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0XFF010d75))),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeExtraLarge,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    final categoryList =
                                        categoryController.categoryList ?? [];
                                    final int itemCount =
                                        categoryList.length > 16
                                            ? 16
                                            : categoryList.length;
                                    final int rowCount = (itemCount / 4).ceil();

                                    return LayoutBuilder(
                                      builder: (context, constraints) {
                                        final double maxHeightPerRow =
                                            constraints.maxWidth /
                                                2.9; // Adjust according to width

                                        return IntrinsicHeight(
                                          child: SizedBox(
                                            height: maxHeightPerRow * rowCount,
                                            child: categoryList.isNotEmpty
                                                ? GridView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: itemCount,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: Dimensions
                                                          .paddingSizeSmall,
                                                      top: Dimensions
                                                          .paddingSizeDefault,
                                                    ),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      mainAxisSpacing: 65,
                                                      crossAxisSpacing:
                                                          Dimensions
                                                              .paddingSizeSmall,
                                                      childAspectRatio: 1,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: 0,
                                                          right: Dimensions
                                                              .paddingSizeSmall,
                                                          top: 0,
                                                        ),
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (index == 15 &&
                                                                itemCount >
                                                                    16) {
                                                              Get.toNamed(
                                                                  RouteHelper
                                                                      .getCategoryRoute());
                                                            } else {
                                                              Get.toNamed(
                                                                  RouteHelper
                                                                      .getCategoryItemRoute(
                                                                categoryController
                                                                    .categoryList![
                                                                        index]
                                                                    .id,
                                                                categoryController
                                                                    .categoryList![
                                                                        index]
                                                                    .name!,
                                                              ));
                                                            }
                                                          },
                                                          child: Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radiusSmall),
                                                                child: CustomImage(
                                                                  image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 6),
                                                              Text(
                                                                categoryController
                                                                    .categoryList![
                                                                        index]
                                                                    .name!,
                                                                style: robotoMedium.copyWith(
                                                                    fontSize:
                                                                        11,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .color),
                                                                maxLines:
                                                                    Get.find<LocalizationController>()
                                                                            .isLtr
                                                                        ? 2
                                                                        : 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : CategoryShimmer(
                                                    categoryController:
                                                        categoryController),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              ResponsiveHelper.isMobile(context)
                                  ? const SizedBox()
                                  : categoryController.categoryList != null
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (con) => Dialog(
                                                    child: SizedBox(
                                                      height: 550,
                                                      width: 600,
                                                      child: CategoryPopUp(
                                                        categoryController:
                                                            categoryController,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )
                                      : CategoryShimmer(
                                          categoryController:
                                              categoryController),
                            ],
                          ),
                        ],
                      );
      });
    });
  }
}

class PharmacyCategoryView extends StatelessWidget {
  final CategoryController categoryController;
  const PharmacyCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 160,
        child: categoryController.categoryList != null
            ? ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeDefault,
                    top: Dimensions.paddingSizeDefault),
                itemCount: categoryController.categoryList!.length > 10
                    ? 10
                    : categoryController.categoryList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeSmall,
                        top: Dimensions.paddingSizeDefault),
                    child: InkWell(
                      onTap: () {
                        if (index == 9 &&
                            categoryController.categoryList!.length > 10) {
                          Get.toNamed(RouteHelper.getCategoryRoute());
                        } else {
                          Get.toNamed(RouteHelper.getCategoryItemRoute(
                            categoryController.categoryList![index].id,
                            categoryController.categoryList![index].name!,
                          ));
                        }
                      },
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.3),
                              Theme.of(context).cardColor.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Column(children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    topRight: Radius.circular(100)),
                                child: CustomImage(
                                  image:
                                      '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                  height: 60,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              (index == 9 &&
                                      categoryController.categoryList!.length >
                                          10)
                                  ? Positioned(
                                      right: 0,
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(100),
                                                    topRight:
                                                        Radius.circular(100)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.4),
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.6),
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.4),
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+${categoryController.categoryList!.length - 10}',
                                              style: robotoMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraLarge,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Expanded(
                              child: Text(
                            (index == 9 &&
                                    categoryController.categoryList!.length >
                                        10)
                                ? 'see_all'.tr
                                : categoryController.categoryList![index].name!,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: (index == 9 &&
                                        categoryController
                                                .categoryList!.length >
                                            10)
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          )),
                        ]),
                      ),
                    ),
                  );
                },
              )
            : PharmacyCategoryShimmer(categoryController: categoryController),
      ),
    ]);
  }
}

class FoodCategoryView extends StatelessWidget {
  final CategoryController categoryController;
  const FoodCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 160,
          child: categoryController.categoryList != null
              ? ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeDefault,
                      top: Dimensions.paddingSizeDefault),
                  itemCount: categoryController.categoryList!.length > 10
                      ? 10
                      : categoryController.categoryList!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeDefault,
                          right: Dimensions.paddingSizeDefault,
                          top: Dimensions.paddingSizeDefault),
                      child: InkWell(
                        onTap: () {
                          if (index == 9 &&
                              categoryController.categoryList!.length > 10) {
                            Get.toNamed(RouteHelper.getCategoryRoute());
                          } else {
                            Get.toNamed(RouteHelper.getCategoryItemRoute(
                              categoryController.categoryList![index].id,
                              categoryController.categoryList![index].name!,
                            ));
                          }
                        },
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        child: SizedBox(
                          width: 60,
                          child: Column(children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: CustomImage(
                                    image:
                                        '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                    height: 60,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                (index == 9 &&
                                        categoryController
                                                .categoryList!.length >
                                            10)
                                    ? Positioned(
                                        right: 0,
                                        left: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.6),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '+${categoryController.categoryList!.length - 10}',
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: Text(
                              (index == 9 &&
                                      categoryController.categoryList!.length >
                                          10)
                                  ? 'see_all'.tr
                                  : categoryController
                                          .categoryList![index].name ??
                                      '',
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: (index == 9 &&
                                          categoryController
                                                  .categoryList!.length >
                                              10)
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )),
                          ]),
                        ),
                      ),
                    );
                  },
                )
              : FoodCategoryShimmer(categoryController: categoryController),
        ),
      ]),
    ]);
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const CategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 8,
      padding: const EdgeInsets.only(
          left: Dimensions.paddingSizeSmall,
          top: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 1, vertical: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 80,
              child: Column(children: [
                Container(
                    height: 324,
                    width: 75,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                      right: Dimensions.paddingSizeExtraSmall,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Padding(
                  padding: EdgeInsets.only(
                      right: index == 0 ? Dimensions.paddingSizeExtraSmall : 0),
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Number of columns
        mainAxisSpacing: Dimensions.paddingSizeDefault,
        crossAxisSpacing: Dimensions.paddingSizeSmall,
        childAspectRatio: 1,
      ),
    );
  }
}

class FoodCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const FoodCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 60,
              child: Column(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class PharmacyCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const PharmacyCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Container(
              width: 70,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100)),
              ),
              child: Column(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100)),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
