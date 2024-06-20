import 'package:yehlo_User/features/search/controllers/search_controller.dart' as search;
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/common/widgets/footer_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yehlo_User/common/widgets/item_view.dart';
import 'package:yehlo_User/common/widgets/web_item_view.dart';

class ItemViewWidget extends StatelessWidget {
  final bool isItem;
  const ItemViewWidget({super.key, required this.isItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<search.SearchController>(builder: (searchController) {
        return SingleChildScrollView(
          child: FooterView(
            child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: ResponsiveHelper.isDesktop(context) ? WebItemsView(
                  isStore: isItem, items: searchController.searchItemList, stores: searchController.searchStoreList,
                ) : ItemsView(
                  isStore: isItem, items: searchController.searchItemList, stores: searchController.searchStoreList,
                ),
            ),
          ),
        );
      }),
    );
  }
}
