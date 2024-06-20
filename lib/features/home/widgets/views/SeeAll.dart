import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:yehlo_User/common/widgets/custom_image.dart';
import 'package:yehlo_User/common/widgets/title_widget.dart';
import 'package:yehlo_User/features/category/controllers/category_controller.dart';
import 'package:yehlo_User/features/home/widgets/category_pop_up.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/helper/route_helper.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/styles.dart';

class SeeAllCateg extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null && categoryController.categoryList!.isEmpty)
          ? Center(
      child: SizedBox(
        width: 500,
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
              child:
              TitleWidget(title: 'categories'.tr),
            ),
            Expanded(
              child: SizedBox(
                height: 80,
                child: categoryController.categoryList != null ? GridView.builder(
                  itemCount: categoryController.categoryList!.length,
                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.2,
                    crossAxisCount: GetPlatform.isDesktop ? 5 : 4,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      child: InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getCategoryItemRoute(
                          categoryController.categoryList![index].id, categoryController.categoryList![index].name!,
                        )),
                        child: SizedBox(
                          width: 50,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50, width: 50,
                                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                                  ),
                                  child: CustomImage(
                                    image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                    height: 50, width: 50, fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  categoryController.categoryList![index].name!,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                ),
                              ]),
                        ),
                      ),
                    );
                  },
                ) : CategoryShimmer(categoryController: categoryController),
              ),
            ),
          ],
        ),
      ),
    ): CategoryShimmer(categoryController: categoryController);
      
    }
    );
  }
}