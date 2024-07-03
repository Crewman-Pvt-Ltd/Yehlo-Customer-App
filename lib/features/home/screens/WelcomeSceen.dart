import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yehlo_User/features/home/widgets/module_view.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/util/app_constants.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
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
                          180, // Setting a fixed height to avoid unbounded height issue
                      // color: Colors.grey.withOpacity(0.7),
                      child: Stack(
                        children: [
                          // ColorFiltered(
                          //   colorFilter: ColorFilter.mode(
                          //     Colors.black.withOpacity(0.3),
                          //     BlendMode.darken,
                          //   ),
                          CachedNetworkImage(
                            imageUrl: bannerUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 330, // Match the height of the container
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),

                          Positioned(
                            bottom: 20,
                            left: 20,
                            top: 18,
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
                    const SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
