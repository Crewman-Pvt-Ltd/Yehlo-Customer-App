import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:yehlo_User/features/language/controllers/language_controller.dart';
import 'package:yehlo_User/features/location/controllers/location_controller.dart';
import 'package:yehlo_User/features/splash/controllers/splash_controller.dart';
import 'package:yehlo_User/features/auth/controllers/auth_controller.dart';
import 'package:yehlo_User/features/auth/domain/models/signup_body_model.dart';
import 'package:yehlo_User/features/auth/screens/sign_in_screen.dart';
import 'package:yehlo_User/features/auth/widgets/condition_check_box_widget.dart';
import 'package:yehlo_User/helper/custom_validator.dart';
import 'package:yehlo_User/helper/responsive_helper.dart';
import 'package:yehlo_User/helper/route_helper.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/images.dart';
import 'package:yehlo_User/util/styles.dart';
import 'package:yehlo_User/common/widgets/custom_button.dart';
import 'package:yehlo_User/common/widgets/custom_snackbar.dart';
import 'package:yehlo_User/common/widgets/custom_text_field.dart';
import 'package:yehlo_User/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  Future<void> _showOTPDialog(String phoneNumber, String generatedOTP) {
    final otpController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          title: const Text('Enter OTP'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PinCodeTextField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: otpController,
                  autoFocus: true,
                  pinTheme: PinTheme(
                    //fieldWidth: 0,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    borderWidth: 1,
                    inactiveFillColor: Colors.white,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.grey,
                    activeColor: Colors.black,
                    selectedColor: Colors.black,
                    inactiveColor: Colors.grey.shade200,
                  ),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.white,
                  appContext: context,
                  length: 6,
                  onChanged: (value) {
                    print("Entered OTP: $value");
                  },
                  onCompleted: (value) {},
                ),
                SizedBox(height: 16), // Add some vertical space here
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0XFF010d75)),
                  shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
              onPressed: () async {
                // Verify the OTP here
                String enteredOTP = otpController.text;
                if (enteredOTP == generatedOTP) {
                  isOTPVerified = true;
                  // Handle error
                  Get.snackbar(
                    'Otp Verified Successfully',
                    '',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );

                  Navigator.of(context).pop();
                } else {
                  Get.snackbar(
                    'Enter Correct OTP',
                    '',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
  
  bool isOTPVerified = false;
  bool isPhoneNumberVerified = false;
  bool showResendButton = false;

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel!.country!)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Colors.transparent
          : Theme.of(context).cardColor,
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
          child: Center(
        child: Container(
          width: context.width > 700 ? 700 : context.width,
          padding: context.width > 700
              ? const EdgeInsets.all(0)
              : const EdgeInsets.all(Dimensions.paddingSizeLarge),
          margin: context.width > 700
              ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
              : null,
          decoration: context.width > 700
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                )
              : null,
          child: GetBuilder<AuthController>(builder: (authController) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  ResponsiveHelper.isDesktop(context)
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.clear),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: ResponsiveHelper.isDesktop(context)
                        ? const EdgeInsets.all(40)
                        : EdgeInsets.zero,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.logo, width: 125),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text('sign_up'.tr,
                                style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Row(children: [
                            Expanded(
                              child: CustomTextField(
                                titleText: 'first_name'.tr,
                                hintText: 'ex_jhon'.tr,
                                controller: _firstNameController,
                                focusNode: _firstNameFocus,
                                nextFocus: _lastNameFocus,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                                prefixIcon: Icons.person,
                                showTitle: ResponsiveHelper.isDesktop(context),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                              child: CustomTextField(
                                titleText: 'last_name'.tr,
                                hintText: 'ex_doe'.tr,
                                controller: _lastNameController,
                                focusNode: _lastNameFocus,
                                nextFocus: ResponsiveHelper.isDesktop(context)
                                    ? _emailFocus
                                    : _phoneFocus,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                                prefixIcon: Icons.person,
                                showTitle: ResponsiveHelper.isDesktop(context),
                              ),
                            )
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Row(children: [
                            ResponsiveHelper.isDesktop(context)
                                ? Expanded(
                                    child: CustomTextField(
                                      titleText: 'email'.tr,
                                      hintText: 'enter_email'.tr,
                                      controller: _emailController,
                                      focusNode: _emailFocus,
                                      nextFocus:
                                          ResponsiveHelper.isDesktop(context)
                                              ? _phoneFocus
                                              : _passwordFocus,
                                      inputType: TextInputType.emailAddress,
                                      prefixImage: Images.mail,
                                      showTitle:
                                          ResponsiveHelper.isDesktop(context),
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                                width: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.paddingSizeSmall
                                    : 0),
                            Expanded(
                              child: CustomTextField(
                                isEnabled: !isPhoneNumberVerified,
                                titleText: ResponsiveHelper.isDesktop(context)
                                    ? 'phone'.tr
                                    : 'enter_phone_number'.tr,
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                nextFocus: ResponsiveHelper.isDesktop(context)
                                    ? _passwordFocus
                                    : _emailFocus,
                                inputType: TextInputType.phone,
                                isPhone: true,
                                showTitle: ResponsiveHelper.isDesktop(context),
                                onCountryChanged: (CountryCode countryCode) {
                                  _countryDialCode = countryCode.dialCode;
                                },
                                countryDialCode: _countryDialCode != null
                                    ? CountryCode.fromCountryCode(
                                            Get.find<SplashController>()
                                                .configModel!
                                                .country!)
                                        .code
                                    : Get.find<LocalizationController>()
                                        .locale
                                        .countryCode,
                                onChanged: (value) async {
                                  // Check if the entered value is a 10-digit phone number
                                  if (value.length == 10 &&
                                      value
                                              .replaceAll(RegExp(r'\D'), '')
                                              .length ==
                                          10) {
                                    // If the country dial code is set
                                    if (_countryDialCode != null) {
                                      // Clean the phone number by removing non-numeric characters
                                      final cleanedPhoneNumber =
                                          value.replaceAll(RegExp(r'\D'), '');

                                      // Generate a random OTP
                                      final otp = generateOTP();

                                      print(
                                          'Phone number sent to API: $cleanedPhoneNumber');
                                      print('OTP sent to API: $otp');
                                      // Pass the cleaned phone number to the API
                                      final response = await http.get(Uri.parse(
                                          'https://www.fast2sms.com/dev/bulkV2?authorization=$authorizationKey&route=$route&numbers=$cleanedPhoneNumber&variables_values=$otp'));

                                      if (response.statusCode == 200) {
                                        Get.snackbar(
                                          'Otp Sent Successfully',
                                          '',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                        );
                                        // OTP sent successfully, show the OTP dialog
                                        _showOTPDialog(cleanedPhoneNumber, otp);

                                        isPhoneNumberVerified = true;
                                        // Disable the phone number field
                                        // Assuming _phoneNumberController is your TextEditingController
                                        _phoneController.text =
                                            cleanedPhoneNumber;
                                        _phoneController
                                          ..text = cleanedPhoneNumber
                                          ..selection = TextSelection.collapsed(
                                              offset:
                                                  cleanedPhoneNumber.length);
                                      } else {
                                        // Handle error
                                        // Handle error
                                        Get.snackbar(
                                          'Failed to send OTP',
                                          response.body,
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: [
                                if (isOTPVerified) // Conditionally display the check mark icon
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          !ResponsiveHelper.isDesktop(context)
                              ? CustomTextField(
                                  titleText: 'email'.tr,
                                  hintText: 'enter_email'.tr,
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  nextFocus: _passwordFocus,
                                  inputType: TextInputType.emailAddress,
                                  prefixIcon: Icons.mail,
                                )
                              : const SizedBox(),
                          SizedBox(
                              height: !ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.paddingSizeLarge
                                  : 0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(children: [
                                    CustomTextField(
                                      titleText: 'password'.tr,
                                      hintText: '8_character'.tr,
                                      controller: _passwordController,
                                      focusNode: _passwordFocus,
                                      nextFocus: _confirmPasswordFocus,
                                      inputType: TextInputType.visiblePassword,
                                      prefixIcon: Icons.lock,
                                      isPassword: true,
                                      showTitle:
                                          ResponsiveHelper.isDesktop(context),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                    width: ResponsiveHelper.isDesktop(context)
                                        ? Dimensions.paddingSizeSmall
                                        : 0),
                                ResponsiveHelper.isDesktop(context)
                                    ? Expanded(
                                        child: CustomTextField(
                                        titleText: 'confirm_password'.tr,
                                        hintText: '8_character'.tr,
                                        controller: _confirmPasswordController,
                                        focusNode: _confirmPasswordFocus,
                                        nextFocus: Get.find<SplashController>()
                                                    .configModel!
                                                    .refEarningStatus ==
                                                1
                                            ? _referCodeFocus
                                            : null,
                                        inputAction:
                                            Get.find<SplashController>()
                                                        .configModel!
                                                        .refEarningStatus ==
                                                    1
                                                ? TextInputAction.next
                                                : TextInputAction.done,
                                        inputType:
                                            TextInputType.visiblePassword,
                                        prefixIcon: Icons.lock,
                                        isPassword: true,
                                        showTitle:
                                            ResponsiveHelper.isDesktop(context),
                                        onSubmit: (text) => (GetPlatform.isWeb)
                                            ? _register(authController,
                                                _countryDialCode!)
                                            : null,
                                      ))
                                    : const SizedBox()
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          !ResponsiveHelper.isDesktop(context)
                              ? CustomTextField(
                                  titleText: 'confirm_password'.tr,
                                  hintText: '8_character'.tr,
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocus,
                                  nextFocus: Get.find<SplashController>()
                                              .configModel!
                                              .refEarningStatus ==
                                          1
                                      ? _referCodeFocus
                                      : null,
                                  inputAction: Get.find<SplashController>()
                                              .configModel!
                                              .refEarningStatus ==
                                          1
                                      ? TextInputAction.next
                                      : TextInputAction.done,
                                  inputType: TextInputType.visiblePassword,
                                  prefixIcon: Icons.lock,
                                  isPassword: true,
                                  onSubmit: (text) => (GetPlatform.isWeb)
                                      ? _register(
                                          authController, _countryDialCode!)
                                      : null,
                                )
                              : const SizedBox(),
                          SizedBox(
                              height: !ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.paddingSizeLarge
                                  : 0),
                          (Get.find<SplashController>()
                                      .configModel!
                                      .refEarningStatus ==
                                  1)
                              ? CustomTextField(
                                  titleText: 'refer_code'.tr,
                                  hintText: 'enter_refer_code'.tr,
                                  controller: _referCodeController,
                                  focusNode: _referCodeFocus,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.text,
                                  capitalization: TextCapitalization.words,
                                  prefixImage: Images.referCode,
                                  prefixSize: 14,
                                  showTitle:
                                      ResponsiveHelper.isDesktop(context),
                                )
                              : const SizedBox(),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          const ConditionCheckBoxWidget(forDeliveryMan: true),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          CustomButton(
                            height:
                                ResponsiveHelper.isDesktop(context) ? 45 : null,
                            width: ResponsiveHelper.isDesktop(context)
                                ? 180
                                : null,
                            radius: ResponsiveHelper.isDesktop(context)
                                ? Dimensions.radiusSmall
                                : Dimensions.radiusDefault,
                            isBold: !ResponsiveHelper.isDesktop(context),
                            fontSize: ResponsiveHelper.isDesktop(context)
                                ? Dimensions.fontSizeExtraSmall
                                : null,
                            buttonText: 'sign_up'.tr,
                            isLoading: authController.isLoading,
                            onPressed: authController.acceptTerms
                                ? () =>
                                    _register(authController, _countryDialCode!)
                                : null,
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraLarge),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('already_have_account'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor)),
                                InkWell(
                                  onTap: () {
                                    if (ResponsiveHelper.isDesktop(context)) {
                                      Get.back();
                                      Get.dialog(const SignInScreen(
                                          exitFromApp: false,
                                          backFromThis: false));
                                    } else {
                                      if (Get.currentRoute ==
                                          RouteHelper.signUp) {
                                        Get.back();
                                      } else {
                                        Get.toNamed(RouteHelper.getSignInRoute(
                                            RouteHelper.signUp));
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeExtraSmall),
                                    child: Text('sign_in'.tr,
                                        style: robotoMedium.copyWith(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                ),
                              ]),
                        ]),
                  ),
                ],
              ),
            );
          }),
        ),
      )),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String number = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();

    String numberWithCountryCode = countryCode + number;
    PhoneValid phoneValid =
        await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (password != confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else {
      SignUpBodyModel signUpBody = SignUpBodyModel(
        fName: firstName,
        lName: lastName,
        email: email,
        phone: numberWithCountryCode,
        password: password,
        refCode: referCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel!.customerVerification!) {
            List<int> encoded = utf8.encode(password);
            String data = base64Encode(encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode,
                status.message, RouteHelper.signUp, data));
          } else {
            Get.find<LocationController>()
                .navigateToLocationScreen(RouteHelper.signUp);
            if (ResponsiveHelper.isDesktop(context)) {
              Get.back();
            }
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }

  String generateOTP() {
    Random random = Random();
    // Generate a random 6-digit OTP
    return random.nextInt(999999).toString().padLeft(6, '0');
  }

  final String authorizationKey =
      'R1cfeUkSfQ7BiXnUzvekzLwkH1YXjKwGMI1aMzaVYn3Vl1l93xL2hbQXbPX0'; // Replace 'YOUR_API_KEY' with your actual API key
  final String route = 'otp';
}
