import 'package:flutter/cupertino.dart';
import 'package:yehlo_User/features/banner/controllers/banner_controller.dart';
//import 'package:yehlo_User/features/home/plan_price.dart';
import 'package:yehlo_User/features/home/screens/WelcomeSceen.dart';
import 'package:yehlo_User/features/home/widgets/HomeScreenModelView.dart';
import 'package:yehlo_User/features/home/widgets/Weather_Info.dart';
//import 'package:yehlo_User/features/home/widgets/bad_weather_widget.dart';
import 'package:yehlo_User/features/item/controllers/campaign_controller.dart';
import 'package:yehlo_User/features/category/controllers/category_controller.dart';
import 'package:yehlo_User/features/coupon/controllers/coupon_controller.dart';
import 'package:yehlo_User/features/flash_sale/controllers/flash_sale_controller.dart';
import 'package:yehlo_User/features/language/controllers/language_controller.dart';
import 'package:yehlo_User/features/location/controllers/location_controller.dart';
import 'package:yehlo_User/features/notification/controllers/notification_controller.dart';
import 'package:yehlo_User/features/item/controllers/item_controller.dart';
import 'package:yehlo_User/features/store/controllers/store_controller.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/features/profile/controllers/profile_controller.dart';
import 'package:yehlo_User/features/address/controllers/address_controller.dart';
import 'package:yehlo_User/features/home/screens/modules/food_home_screen.dart';
import 'package:yehlo_User/features/home/screens/modules/grocery_home_screen.dart';
import 'package:yehlo_User/features/home/screens/modules/pharmacy_home_screen.dart';
import 'package:yehlo_User/features/home/screens/modules/shop_home_screen.dart';
import 'package:yehlo_User/features/parcel/controllers/parcel_controller.dart';
import 'package:yehlo_User/helper/address_helper.dart';
import 'package:yehlo_User/helper/auth_helper.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/helper/route_helper.dart';
import 'package:yehlo_User/util/app_constants.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/images.dart';
import 'package:yehlo_User/util/styles.dart';
import 'package:yehlo_User/common/widgets/item_view.dart';
import 'package:yehlo_User/common/widgets/menu_drawer.dart';
import 'package:yehlo_User/common/widgets/paginated_list_view.dart';
import 'package:yehlo_User/common/widgets/web_menu_bar.dart';
import 'package:yehlo_User/features/home/screens/web_new_home_screen.dart';
import 'package:yehlo_User/features/home/widgets/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:yehlo_User/features/home/widgets/module_view.dart';
import 'package:flutter/rendering.dart';
import 'package:yehlo_User/features/parcel/screens/parcel_category_screen.dart';
import '../../store/domain/models/store_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Future<void> loadData(bool reload, {bool fromModule = false}) async {
    Get.find<LocationController>().syncZoneData();
    Get.find<FlashSaleController>().setEmptyFlashSale(fromModule: fromModule);
    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<BannerController>().getBannerList(reload);
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.grocery) {
        Get.find<FlashSaleController>().getFlashSale(reload, false);
      }
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.ecommerce) {
        Get.find<ItemController>().getFeaturedCategoriesItemList(false, false);
        Get.find<FlashSaleController>().getFlashSale(reload, false);
      }
      Get.find<BannerController>().getPromotionalBannerList(reload);
      Get.find<ItemController>().getDiscountedItemList(reload, false, 'all');
      Get.find<CategoryController>().getCategoryList(reload);
      Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<CampaignController>().getBasicCampaignList(reload);
      Get.find<CampaignController>().getItemCampaignList(reload);
      Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      Get.find<ItemController>().getRecommendedItemList(reload, 'all', false);
      Get.find<StoreController>().getStoreList(1, reload);
      Get.find<StoreController>().getRecommendedStoreList();
    }
    if (AuthHelper.isLoggedIn()) {
      Get.find<ProfileController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<StoreController>()
          .getVisitAgainStoreList(fromModule: fromModule);
      Get.find<CouponController>().getCouponList();
    }
    Get.find<SplashController>().getModules();
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (AuthHelper.isLoggedIn()) {
        Get.find<AddressController>().getAddressList();
      }
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.pharmacy) {
      Get.find<ItemController>().getBasicMedicine(reload, false);
      Get.find<StoreController>().getFeaturedStoreList();
      await Get.find<ItemController>().getCommonConditions(false);
      if (Get.find<ItemController>().commonConditions!.isNotEmpty) {
        Get.find<ItemController>().getConditionsWiseItem(
            Get.find<ItemController>().commonConditions![0].id!, false);
      }
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isSearchBarPinned = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    HomeScreen.loadData(false);
    if (!ResponsiveHelper.isWeb()) {
      Get.find<LocationController>().getZone(
          AddressHelper.getUserAddressFromSharedPref()!.latitude,
          AddressHelper.getUserAddressFromSharedPref()!.longitude,
          false,
          updateInAddress: true);
    }
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Scrolling down
      setState(() {
        _isSearchBarPinned = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // Scrolling up
      setState(() {
        _isSearchBarPinned = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) &&
          splashController.module == null &&
          splashController.configModel!.module == null;
      bool isParcel = splashController.module != null &&
          splashController.configModel!.moduleConfig!.module!.isParcel!;
      bool isPharmacy = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.pharmacy;
      bool isFood = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.food;
      bool isShop = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.ecommerce;
      bool isGrocery = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.grocery;

      return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: isParcel
            ? const ParcelCategoryScreen()
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    splashController.setRefreshing(true);
                    if (Get.find<SplashController>().module != null) {
                      await Get.find<LocationController>().syncZoneData();
                      await Get.find<BannerController>().getBannerList(true);
                      if (isGrocery) {
                        await Get.find<FlashSaleController>()
                            .getFlashSale(true, true);
                      }
                      await Get.find<BannerController>()
                          .getPromotionalBannerList(true);
                      await Get.find<ItemController>()
                          .getDiscountedItemList(true, false, 'all');
                      await Get.find<CategoryController>()
                          .getCategoryList(true);
                      await Get.find<StoreController>()
                          .getPopularStoreList(true, 'all', false);
                      await Get.find<CampaignController>()
                          .getItemCampaignList(true);
                      Get.find<CampaignController>().getBasicCampaignList(true);
                      await Get.find<ItemController>()
                          .getPopularItemList(true, 'all', false);
                      await Get.find<StoreController>()
                          .getLatestStoreList(true, 'all', false);
                      await Get.find<ItemController>()
                          .getReviewedItemList(true, 'all', false);
                      await Get.find<StoreController>().getStoreList(1, true);
                      if (AuthHelper.isLoggedIn()) {
                        await Get.find<ProfileController>().getUserInfo();
                        await Get.find<NotificationController>()
                            .getNotificationList(true);
                        Get.find<CouponController>().getCouponList();
                      }
                      if (isPharmacy) {
                        Get.find<ItemController>().getBasicMedicine(true, true);
                        Get.find<ItemController>().getCommonConditions(true);
                      }
                      if (isShop) {
                        await Get.find<FlashSaleController>()
                            .getFlashSale(true, true);
                        Get.find<ItemController>()
                            .getFeaturedCategoriesItemList(true, true);
                      }
                    } else {
                      await Get.find<BannerController>().getFeaturedBanner();
                      await Get.find<SplashController>().getModules();
                      if (AuthHelper.isLoggedIn()) {
                        await Get.find<AddressController>().getAddressList();
                      }
                      await Get.find<StoreController>().getFeaturedStoreList();
                    }
                    splashController.setRefreshing(false);
                  },
                  child: ResponsiveHelper.isDesktop(context)
                      ? WebNewHomeScreen(
                          scrollController: _scrollController,
                        )
                      : CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            /// App Bar
                            SliverAppBar(
                              pinned: true,
                              floating: true,
                              elevation: 3,
                              automaticallyImplyLeading: false,
                              surfaceTintColor:
                                  Theme.of(context).colorScheme.background,
                              backgroundColor:
                                  ResponsiveHelper.isDesktop(context)
                                      ? Colors.transparent
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                              title: Center(
                                child: Container(
                                  width: Dimensions.webMaxWidth,
                                  height:
                                      Get.find<LocalizationController>().isLtr
                                          ? 60
                                          : 70,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Row(
                                    children: [
                                      (splashController.module != null &&
                                              splashController
                                                      .configModel!.module ==
                                                  null)
                                          ? InkWell(
                                              onTap: () => splashController
                                                  .removeModule(),
                                              child: Image.asset(
                                                  Images.moduleIcon,
                                                  height: 25,
                                                  width: 25,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                          width: (splashController.module !=
                                                      null &&
                                                  splashController.configModel!
                                                          .module ==
                                                      null)
                                              ? Dimensions.paddingSizeSmall
                                              : 0),
                                      Image.asset(
                                        'assets/image/Yehlo_fab.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () =>
                                            Get.find<LocationController>()
                                                .navigateToLocationScreen(
                                                    'home'),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeSmall,
                                            horizontal: ResponsiveHelper
                                                    .isDesktop(context)
                                                ? Dimensions.paddingSizeSmall
                                                : 0,
                                          ),
                                          child: GetBuilder<LocationController>(
                                              builder: (locationController) {
                                            return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AddressHelper
                                                            .getUserAddressFromSharedPref()!
                                                        .addressType!
                                                        .tr,
                                                    style:
                                                        robotoMedium.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color,
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(children: [
                                                    Flexible(
                                                      child: Text(
                                                        AddressHelper
                                                                .getUserAddressFromSharedPref()!
                                                            .address!,
                                                        style: robotoRegular
                                                            .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.expand_more,
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                      size: 18,
                                                    ),
                                                  ]),
                                                ]);
                                          }),
                                        ),
                                      )),
                                      const WeatherInfo(),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            child: GetBuilder<
                                                    NotificationController>(
                                                builder:
                                                    (notificationController) {
                                              return Stack(children: [
                                                Icon(CupertinoIcons.bell,
                                                    size: 25,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color),
                                                notificationController
                                                        .hasNotification
                                                    ? Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          height: 10,
                                                          width: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor),
                                                          ),
                                                        ))
                                                    : const SizedBox(),
                                              ]);
                                            }),
                                            onTap: () => Get.toNamed(RouteHelper
                                                .getNotificationRoute()),
                                          ),
                                          if (!_isSearchBarPinned)
                                            IconButton(
                                              icon: const Icon(Icons.search),
                                              onPressed: () => Get.toNamed(
                                                  RouteHelper.getSearchRoute()),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: const [SizedBox()],
                            ),

                            /// Search Button
                            !showMobileModule
                                ? SliverPersistentHeader(
                                    pinned: false,
                                    delegate: SliverDelegate(
                                        child: Center(
                                            child: Container(
                                      height: 50, width: Dimensions.webMaxWidth,
                                      // color: Theme.of(context).colorScheme.background,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeSmall),
                                      child: InkWell(
                                        onTap: () => Get.toNamed(
                                            RouteHelper.getSearchRoute()),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.2),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: const Offset(2, 3))
                                            ],
                                          ),
                                          child: Row(children: [
                                            Icon(
                                              CupertinoIcons.search,
                                              size: 25,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Expanded(
                                                child: Text(
                                              Get.find<SplashController>()
                                                      .configModel!
                                                      .moduleConfig!
                                                      .module!
                                                      .showRestaurantText!
                                                  ? 'search_food_or_restaurant'
                                                      .tr
                                                  : 'search_item_or_store'.tr,
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            )),
                                          ]),
                                        ),
                                      ),
                                    ))),
                                  )
                                : const SliverToBoxAdapter(),

                            SliverToBoxAdapter(
                              child: Center(
                                child: SizedBox(
                                    width: Dimensions.webMaxWidth,
                                    child: !showMobileModule
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                HomeScreenModuleView(
                                                  splashController:
                                                      splashController,
                                                ),
                                                isGrocery
                                                    ? const GroceryHomeScreen()
                                                    : isPharmacy
                                                        ? const PharmacyHomeScreen()
                                                        : isFood
                                                            ? const FoodHomeScreen()
                                                            : isShop
                                                                ? const ShopHomeScreen()
                                                                : const SizedBox(),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      Get.find<LocalizationController>()
                                                              .isLtr
                                                          ? 10
                                                          : 0,
                                                      15,
                                                      0,
                                                      5),
                                                  child: GetBuilder<
                                                          StoreController>(
                                                      builder:
                                                          (storeController) {
                                                    return Row(children: [
                                                      Expanded(
                                                          child: Padding(
                                                        padding: EdgeInsets.only(
                                                            right: Get.find<
                                                                        LocalizationController>()
                                                                    .isLtr
                                                                ? 0
                                                                : 10),
                                                        child: Text(
                                                          '${storeController.storeModel?.totalSize ?? 0} ${Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurants'.tr : 'stores'.tr}',
                                                          style: robotoMedium
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge),
                                                        ),
                                                      )),
                                                      FilterView(
                                                          storeController:
                                                              storeController),
                                                    ]);
                                                  }),
                                                ),
                                                GetBuilder<StoreController>(
                                                  builder: (storeController) {
                                                    // Split the store list into two sections
                                                    List<Store>?
                                                        firstSectionStores;
                                                    List<Store>?
                                                        secondSectionStores;

                                                    final stores =
                                                        storeController
                                                                .storeModel
                                                                ?.stores ??
                                                            [];
                                                    if (stores.isNotEmpty) {
                                                      final midIndex =
                                                          stores.length ~/ 2;
                                                      firstSectionStores =
                                                          stores.sublist(
                                                              0, midIndex);
                                                      secondSectionStores =
                                                          stores.sublist(
                                                              midIndex);
                                                    }

                                                    return PaginatedListView(
                                                      scrollController:
                                                          _scrollController,
                                                      totalSize: storeController
                                                          .storeModel
                                                          ?.totalSize,
                                                      offset: storeController
                                                          .storeModel?.offset,
                                                      onPaginate: (int?
                                                              offset) async =>
                                                          await storeController
                                                              .getStoreList(
                                                                  offset!,
                                                                  false),
                                                      itemView: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                ItemsView(
                                                                  isStore: true,
                                                                  items: null,
                                                                  isFoodOrGrocery:
                                                                      (isFood ||
                                                                          isGrocery),
                                                                  stores:
                                                                      firstSectionStores,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal: ResponsiveHelper.isDesktop(
                                                                            context)
                                                                        ? Dimensions
                                                                            .paddingSizeExtraSmall
                                                                        : Dimensions
                                                                            .paddingSizeSmall,
                                                                    vertical: ResponsiveHelper.isDesktop(
                                                                            context)
                                                                        ? Dimensions
                                                                            .paddingSizeExtraSmall
                                                                        : Dimensions
                                                                            .paddingSizeDefault,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  10), // Add spacing between sections
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                ItemsView(
                                                                  isStore: true,
                                                                  items: null,
                                                                  isFoodOrGrocery:
                                                                      (isFood ||
                                                                          isGrocery),
                                                                  stores:
                                                                      secondSectionStores,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal: ResponsiveHelper.isDesktop(
                                                                            context)
                                                                        ? Dimensions
                                                                            .paddingSizeExtraSmall
                                                                        : Dimensions
                                                                            .paddingSizeSmall,
                                                                    vertical: ResponsiveHelper.isDesktop(
                                                                            context)
                                                                        ? Dimensions
                                                                            .paddingSizeExtraSmall
                                                                        : Dimensions
                                                                            .paddingSizeDefault,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                                SizedBox(
                                                    height: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? 0
                                                        : 100),
                                              ])
                                        : SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                .height,
                                            child: const WelcomeScreen())
                                    // ModuleView(
                                    //     splashController: splashController),
                                    ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
      );
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
