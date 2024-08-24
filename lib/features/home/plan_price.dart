import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  List<Plan> _plans = [];
  bool _isLoading = true;
  String result = "";
  String callBackUrl = "https://yehlo.app/payment/phonepe/webhook";
  String packageName = "com.yehlo_User_app";

  @override
  void initState() {
    super.initState();
    _fetchPlans();
    initPhonePeSdk();
  }

  Future<void> _fetchPlans() async {
    const url = 'https://yehlo.app/api/v1/auth/vendor/getplandetails';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _plans = (data['micro'] as List)
              .map<Plan>((json) => Plan.fromJson(json))
              .toList();
          _plans.addAll((data['mini'] as List)
              .map<Plan>((json) => Plan.fromJson(json))
              .toList());
          _plans.addAll((data['mega'] as List)
              .map<Plan>((json) => Plan.fromJson(json))
              .toList());
          _plans.addAll((data['super'] as List)
              .map<Plan>((json) => Plan.fromJson(json))
              .toList());
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load plans');
      }
    } catch (e) {
      print('Error fetching plans: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshPlans() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchPlans();
  }

  void initPhonePeSdk() {
    PhonePePaymentSdk.init('PRODUCTION', '', 'M226DWVS5EFSO', true)
        .then((isInitialized) {
      setState(() {
        result = 'PhonePe SDK Initialized - $isInitialized';
      });
    }).catchError((error) {
      handleError(error);
    });
  }

  void startTransaction(Plan plan) async {
    int amountInPaisa = (double.parse(plan.price) * 100).toInt();
    final data = {
      "merchantId": "M226DWVS5EFSO",
      "merchantTransactionId": "MT${getRandomNumber()}",
      "merchantUserId": "MU${getRandomNumber()}",
      "amount": 100,
      "callbackUrl": callBackUrl,
      "mobileNumber": "7017174051",
      "paymentInstrument": {
        "type": "PAY_PAGE",
      }
    };
    String jsonString = jsonEncode(data);
    const saltkey = "0b577413-c778-48a7-b755-c4303c8c5839";
    const apiEndPoint = "/pg/v1/pay";
    const saltIndex = "1";
    String base64Data = jsonString.toBase64;
    String dataToHash = base64Data + apiEndPoint + saltkey;
    String sHA256 = generateSha256Hash(dataToHash);
    String body = base64Data;
    String checksum = "$sHA256###$saltIndex";

    try {
      PhonePePaymentSdk.startTransaction(
              body, callBackUrl, checksum, packageName)
          .then((response) {
        if (response != null) {
          String status = response['status'].toString();
          String error = response['error'].toString();
          if (status == 'SUCCESS') {
            print(response);
            setState(() {
              result = "Flow Completed - Status: Success!";
              //Get.offAllNamed(RouteHelper.getSuccessScreen());
              print(result);
            });
          } else {
            setState(() {
              result = "Flow Completed - Status: $status and Error: $error";
            });
          }
        } else {
          setState(() {
            result = "Flow Incomplete";
          });
        }
      }).catchError((error) {
        handleError(error);
      });
    } catch (error) {
      handleError(error);
    }
  }

  String generateSha256Hash(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  String getRandomNumber() {
    Random random = Random();
    String randomMerchant = "";
    for (int i = 0; i < 15; i++) {
      randomMerchant += random.nextInt(10).toString();
    }
    debugPrint("random Merchant>>>>> $randomMerchant");
    return randomMerchant;
  }

  void handleError(error) {
    setState(() {
      if (error is Exception) {
        result = error.toString();
      } else {
        result = {"error": error}.toString();
      }
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF44287D),
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Center(
          child: Text(
            'Select Plan',
            style: TextStyle(fontSize: 27, fontFamily: 'Baloo2'),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshPlans,
              child: PlanSlider(
                plans: _plans,
                onSelectPlan: (plan) {
                  _showToast(
                    'Selected Plan:\n${plan.name}\nPrice: ${plan.price}\nProduct Limit: ${plan.productLimit}',
                  );
                  // Start the transaction
                  startTransaction(plan);
                },
              ),
            ),
    );
  }
}

class PlanSlider extends StatefulWidget {
  final List<Plan> plans;
  final Function(Plan) onSelectPlan;

  const PlanSlider({required this.plans, required this.onSelectPlan});

  @override
  _PlanSliderState createState() => _PlanSliderState();
}

class _PlanSliderState extends State<PlanSlider> {
  PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.plans.length,
      itemBuilder: (context, index) {
        bool isCurrentPage = index == _currentPage;
        return Transform.scale(
          scale: isCurrentPage ? 1.1 : 0.8,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 9,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Card(
                color: const Color(0XFFFFFFFF),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        widget.plans[index].imageUrl,
                        height: isCurrentPage ? 160 : 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 0),
                      Text(
                        widget.plans[index].name,
                        style: TextStyle(
                          fontSize: isCurrentPage ? 27 : 20,
                          fontWeight: isCurrentPage
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '₹ ${widget.plans[index].price}',
                        style: TextStyle(
                          fontSize: isCurrentPage ? 28 : 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.plans[index].desc1,
                        style: TextStyle(
                          fontSize: isCurrentPage ? 15 : 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.plans[index].desc2,
                        style: TextStyle(
                          fontSize: isCurrentPage ? 15 : 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.plans[index].desc3,
                        style: TextStyle(
                          fontSize: isCurrentPage ? 15 : 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 24,
                          ),
                        ),
                        onPressed: () {
                          widget.onSelectPlan(widget.plans[index]);
                        },
                        child: const Text(
                          'Select Plan',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Plan {
  final String name;
  final String price;
  final String productLimit;
  final String desc1;
  final String desc2;
  final String desc3;
  final String imageUrl;

  Plan({
    required this.name,
    required this.price,
    required this.productLimit,
    required this.desc1,
    required this.desc2,
    required this.desc3,
    required this.imageUrl,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      productLimit: json['product_limit'] ?? '',
      desc1: json['desc_1'] ?? '',
      desc2: json['desc_2'] ?? '',
      desc3: json['desc_3'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}

extension StringExtensions on String {
  String get toBase64 {
    return base64.encode(utf8.encode(this));
  }
}
