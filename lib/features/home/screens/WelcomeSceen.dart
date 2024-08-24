import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yehlo_User/features/home/widgets/ServiceModelView.dart';
import 'package:yehlo_User/features/home/widgets/module_view.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/util/app_constants.dart';
import 'package:yehlo_User/util/dimensions.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? bannerUrl;
  String? headerTitle;
  String? headerSubtitle;
  String? headerTagLine;
  List<String>? slideBanners;

  @override
  void initState() {
    super.initState();
    FetchFirstBanner();
  }

  Future<void> FetchFirstBanner() async {
    const String apiUrl = 'https://yehlo.app/api/v1/react-landing-page';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bannerUrl = data['base_urls']['header_banner_url'] +
              '/' +
              data['header_banner'];
          headerTitle = data['header_title'];
          headerSubtitle = data['header_sub_title'];
          headerTagLine = data['header_tag_line'];
          slideBanners = List<String>.from(data['promotion_banners'].map(
              (banner) =>
                  data['base_urls']['promotional_banner_url'] +
                  '/' +
                  banner['img']));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: bannerUrl == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height:
                          170, // Setting a fixed height to avoid unbounded height issue
                      // color: Colors.grey.withOpacity(0.7),
                      child: Stack(
                        children: [
                          // ColorFiltered(
                          //    colorFilter: ColorFilter.mode(
                          //    Colors.black.withOpacity(0.3),
                          //    BlendMode.darken,
                          //   ),
                          CachedNetworkImage(
                            imageUrl: bannerUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 332, // Match the height of the container
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),

                          Positioned(
                            bottom: 20,
                            left: 17,
                            top: 10,
                            right: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  headerTitle ?? '',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Baloo2',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  headerSubtitle ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  headerTagLine ?? '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(),
                    ),

                    ModuleView(splashController: splashController),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Divider(),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Services', style: TextStyle(fontSize: 16, color: Colors.black), ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(),
                    ),
                    SizedBox(height: 10,),
                    ServiceModelView(splashController: splashController),
                    const SizedBox(
                      height: 20,
                    ),
                    if (slideBanners != null && slideBanners!.isNotEmpty)
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 130,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          viewportFraction: 0.7,
                          aspectRatio: 1.0,
                        ),
                        items: slideBanners!.map((banner) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors
                                            .grey[Get.isDarkMode ? 800 : 200]!,
                                        spreadRadius: 1,
                                        blurRadius: 5)
                                  ],
                                ),
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                child: CachedNetworkImage(
                                  imageUrl: banner,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
