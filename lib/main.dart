import 'dart:async';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:yehlo_User/features/auth/controllers/auth_controller.dart';
import 'package:yehlo_User/features/cart/controllers/cart_controller.dart';
import 'package:yehlo_User/features/language/controllers/language_controller.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/common/controllers/theme_controller.dart';
import 'package:yehlo_User/features/favourite/controllers/favourite_controller.dart';
import 'package:yehlo_User/features/notification/domain/models/notification_body_model.dart';
import 'package:yehlo_User/helper/address_helper.dart';
import 'package:yehlo_User/helper/auth_helper.dart';
import 'package:yehlo_User/helper/notification_helper.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/helper/route_helper.dart';
import 'package:yehlo_User/theme/dark_theme.dart';
import 'package:yehlo_User/theme/light_theme.dart';
import 'package:yehlo_User/util/app_constants.dart';
import 'package:yehlo_User/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:yehlo_User/features/home/widgets/cookies_view.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
  HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
  FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (GetPlatform.isWeb) {
      await Firebase.initializeApp(
            options: const FirebaseOptions(
            apiKey: "AIzaSyBO4dKvmV3GetE6T21yGz5jtdbVQO76IEM",
            authDomain: "yehlo-4921f.firebaseapp.com",
            databaseURL: "https://yehlo-4921f-default-rtdb.asia-southeast1.firebasedatabase.app",
            projectId: "yehlo-4921f",
            storageBucket: "yehlo-4921f.appspot.com",
            messagingSenderId: "440975246236",
            appId: "1:440975246236:web:5886cd04ac28cc34793e59",
            measurementId: "G-QS68YTLL4B")
            );

    MetaSEO().config();
  }
  await Firebase.initializeApp();
  Map<String, Map<String, String>> languages = await di.init();

  NotificationBodyModel? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (_) {}

  if (ResponsiveHelper.isWeb()) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "380903914182154",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _route();
  }

  void _route() async {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      if (AddressHelper.getUserAddressFromSharedPref() != null &&
         AddressHelper.getUserAddressFromSharedPref()!.zoneIds == null) {
         Get.find<AuthController>().clearSharedAddress();
      }

      if (!AuthHelper.isLoggedIn() && !AuthHelper.isGuestLoggedIn() /*&& !ResponsiveHelper.isDesktop(Get.context!)*/) {
        await Get.find<AuthController>().guestLogin();
      }

      if ((AuthHelper.isLoggedIn() || AuthHelper.isGuestLoggedIn()) &&
          Get.find<SplashController>().cacheModule != null) {
        Get.find<CartController>().getCartDataOnline();
      }
    }
    Get.find<SplashController>()
        .getConfigData(loadLandingData: GetPlatform.isWeb)
        .then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          if (Get.find<SplashController>().module != null) {
            await Get.find<FavouriteController>().getFavouriteList();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null)
              ? const SizedBox()
              : GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch
                    },
                  ),
                  theme: themeController.darkTheme ? dark() : light(),
                  locale: localizeController.locale,
                  translations: Messages(languages: widget.languages),
                  fallbackLocale: Locale(
                  AppConstants.languages[0].languageCode!,
                  AppConstants.languages[0].countryCode),
                  initialRoute: GetPlatform.isWeb
                  ? RouteHelper.getInitialRoute()
                  : RouteHelper.getSplashRoute(widget.body),
                  getPages: RouteHelper.routes,
                  defaultTransition: Transition.topLevel,
                  transitionDuration: const Duration(milliseconds: 500),
                  builder: (BuildContext context, widget) {
                  return MediaQuery(
                        data:  MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
                        child: Material(
                        child: Stack(children: [
                              widget!,
                              GetBuilder<SplashController>(
                              builder: (splashController) {
                              if (!splashController.savedCookiesData &&
                                  !splashController.getAcceptCookiesStatus(
                                          splashController.configModel != null
                                          ? splashController.configModel!.cookiesText!
                                          : '')) {
                                return ResponsiveHelper.isWeb()
                                    ? const Align(
                                        alignment: Alignment.bottomCenter,
                                        child: CookiesView())
                                    : const SizedBox();
                              } else {
                                return const SizedBox();
                              }
                            })
                          ]),
                        ));
                  },
                );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
