import 'package:yehlo_User/common/models/response_model.dart';
import 'package:yehlo_User/features/banner/controllers/banner_controller.dart';
import 'package:yehlo_User/features/item/controllers/campaign_controller.dart';
import 'package:yehlo_User/features/cart/controllers/cart_controller.dart';
import 'package:yehlo_User/features/store/controllers/store_controller.dart';
import 'package:yehlo_User/features/favourite/controllers/favourite_controller.dart';
import 'package:yehlo_User/api/api_client.dart';
import 'package:yehlo_User/features/splash/domain/models/landing_model.dart';
import 'package:yehlo_User/common/models/config_model.dart';
import 'package:yehlo_User/common/models/module_model.dart';
import 'package:get/get.dart';
import 'package:yehlo_User/features/address/controllers/address_controller.dart';
import 'package:yehlo_User/helper/auth_helper.dart';
import 'package:yehlo_User/common/widgets/custom_snackbar.dart';
import 'package:yehlo_User/features/home/screens/home_screen.dart';
import 'package:yehlo_User/features/splash/domain/services/splash_service_interface.dart';

class SplashController extends GetxController implements GetxService {
  SplashController({required this.splashServiceInterface});

  final SplashServiceInterface splashServiceInterface;

  ModuleModel? _cacheModule;
  ConfigModel? _configModel;
  Map<String, dynamic>? _data = {};
  bool _firstTimeConnectionCheck = true;
  bool _hasConnection = true;
  bool _isLoading = false;
  bool _isRefreshing = false;
  LandingModel? _landingModel;
  ModuleModel? _module;
  int _moduleIndex = 0;
  List<ModuleModel>? _moduleList;
  bool _savedCookiesData = false;
  int _selectedModuleIndex = 0;
  bool _webSuggestedLocation = false;

  ConfigModel? get configModel => _configModel;

  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  bool get hasConnection => _hasConnection;

  ModuleModel? get module => _module;

  ModuleModel? get cacheModule => _cacheModule;

  List<ModuleModel>? get moduleList => _moduleList;

  int get moduleIndex => _moduleIndex;

  bool get isLoading => _isLoading;

  int get selectedModuleIndex => _selectedModuleIndex;

  LandingModel? get landingModel => _landingModel;

  bool get savedCookiesData => _savedCookiesData;

  bool get webSuggestedLocation => _webSuggestedLocation;

  bool get isRefreshing => _isRefreshing;

  DateTime get currentTime => DateTime.now();

  void selectModuleIndex(int index) {
    _selectedModuleIndex = index;
    update();
  }

  Future<bool> getConfigData(
      {bool loadModuleData = false, bool loadLandingData = false}) async {
    _hasConnection = true;
    _moduleIndex = 0;
    Response response = await splashServiceInterface.getConfigData();
    bool isSuccess = false;
    if (response.statusCode == 200) {
      _data = response.body;
      _configModel = ConfigModel.fromJson(response.body);
      if (_configModel!.module != null) {
        setModule(_configModel!.module);
      } else if (GetPlatform.isWeb || (loadModuleData && _module != null)) {
        setModule(
            GetPlatform.isWeb ? splashServiceInterface.getModule() : _module);
      }
      if (loadLandingData) {
        await getLandingPageData();
      }
      isSuccess = true;
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        _hasConnection = false;
      }
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  Future<void> getLandingPageData() async {
    LandingModel? landingModel =
        await splashServiceInterface.getLandingPageData();
    if (landingModel != null) {
      _landingModel = landingModel;
    }
    update();
  }

  Future<void> initSharedData() async {
    if (!GetPlatform.isWeb) {
      _module = null;
      splashServiceInterface.initSharedData();
    } else {
      _module = await splashServiceInterface.initSharedData();
    }
    _cacheModule = splashServiceInterface.getCacheModule();
    setModule(_module, notify: false);
  }

  void setCacheConfigModule(ModuleModel? cacheModule) {
    _configModel!.moduleConfig!.module =
        Module.fromJson(_data!['module_config'][cacheModule!.moduleType]);
  }

  bool? showIntro() {
    return splashServiceInterface.showIntro();
  }

  void disableIntro() {
    splashServiceInterface.disableIntro();
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  Future<void> setModule(ModuleModel? module, {bool notify = true}) async {
    _module = module;
    splashServiceInterface.setModule(module);
    if (module != null) {
      if (_configModel != null) {
        _configModel!.moduleConfig!.module =
            Module.fromJson(_data!['module_config'][module.moduleType]);
      }
      await splashServiceInterface.setCacheModule(module);
      if ((AuthHelper.isLoggedIn() || AuthHelper.isGuestLoggedIn()) &&
          Get.find<SplashController>().cacheModule != null) {
        Get.find<CartController>().getCartDataOnline();
      }
    }
    if (AuthHelper.isLoggedIn()) {
      if (Get.find<SplashController>().module != null) {
        Get.find<FavouriteController>().getFavouriteList();
      }
    }
    if (notify) {
      update();
    }
  }

  Module getModuleConfig(String? moduleType) {
    Module module = Module.fromJson(_data!['module_config'][moduleType]);
    moduleType == 'food'
        ? module.newVariation = true
        : module.newVariation = false;
    return module;
  }

  Future<void> getModules({Map<String, String>? headers}) async {
    _moduleIndex = 0;
    List<ModuleModel>? moduleList =
        await splashServiceInterface.getModules(headers: headers);
    if (moduleList != null) {
      _moduleList = [];
      _moduleList!.addAll(moduleList);
    }
    update();
  }

  void switchModule(int index, bool fromPhone) async {
    if (_module == null || _module!.id != _moduleList![index].id) {
      await Get.find<SplashController>().setModule(_moduleList![index]);
      Get.find<CartController>().getCartDataOnline();
      HomeScreen.loadData(true, fromModule: true);
    }
  }

  int getCacheModule() {
    return splashServiceInterface.getCacheModule()?.id ?? 0;
  }

  void setModuleIndex(int index) {
    _moduleIndex = index;
    update();
  }

  void removeModule() {
    setModule(null);
    Get.find<BannerController>().getFeaturedBanner();
    getModules();
    if (AuthHelper.isLoggedIn()) {
      Get.find<AddressController>().getAddressList();
    }
    Get.find<StoreController>().getFeaturedStoreList();
    Get.find<CampaignController>().itemCampaignNull();
  }

  void removeCacheModule() {
    splashServiceInterface.setCacheModule(null);
  }

  Future<bool> subscribeMail(String email) async {
    _isLoading = true;
    update();
    ResponseModel responseModel =
        await splashServiceInterface.subscribeEmail(email);
    if (responseModel.isSuccess) {
      showCustomSnackBar(responseModel.message, isError: false);
    } else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
    return responseModel.isSuccess;
  }

  void saveCookiesData(bool data) {
    splashServiceInterface.saveCookiesData(data);
    _savedCookiesData = true;
    update();
  }

  getCookiesData() {
    _savedCookiesData = splashServiceInterface.getSavedCookiesData();
    update();
  }

  void cookiesStatusChange(String? data) {
    splashServiceInterface.cookiesStatusChange(data);
  }

  bool getAcceptCookiesStatus(String data) =>
      splashServiceInterface.getAcceptCookiesStatus(data);

  void saveWebSuggestedLocationStatus(bool data) {
    splashServiceInterface.saveSuggestedLocationStatus(data);
    _webSuggestedLocation = true;
    update();
  }

  void getWebSuggestedLocationStatus() {
    _webSuggestedLocation = splashServiceInterface.getSuggestedLocationStatus();
  }

  void setRefreshing(bool status) {
    _isRefreshing = status;
    update();
  }
}
