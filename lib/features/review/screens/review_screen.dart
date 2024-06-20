import 'package:yehlo_User/features/review/controllers/review_controller.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/common/widgets/custom_app_bar.dart';
import 'package:yehlo_User/common/widgets/footer_view.dart';
import 'package:yehlo_User/common/widgets/menu_drawer.dart';
import 'package:yehlo_User/common/widgets/no_data_screen.dart';
import 'package:yehlo_User/features/store/widgets/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewScreen extends StatefulWidget {
  final String? storeID;
  const ReviewScreen({super.key, required this.storeID});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<ReviewController>().getStoreReviewList(widget.storeID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
          ? 'restaurant_reviews'.tr : 'store_reviews'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<ReviewController>(builder: (reviewController) {
        return reviewController.storeReviewList != null ? reviewController.storeReviewList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await reviewController.getStoreReviewList(widget.storeID);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(child: SizedBox(width: Dimensions.webMaxWidth, child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                childAspectRatio: (1/0.2), crossAxisSpacing: 10, mainAxisSpacing: 10,
              ),
              itemCount: reviewController.storeReviewList!.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                return ReviewWidget(
                  review: reviewController.storeReviewList![index],
                  hasDivider: index != reviewController.storeReviewList!.length-1,
                );
              },
            )))),
        ) : Center(child: NoDataScreen(text: 'no_review_found'.tr, showFooter: true)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
