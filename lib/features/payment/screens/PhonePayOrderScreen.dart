import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class OrderPhonePayScreen {
  
  final String callBackUrl = "https://yehlo.app/api/v1/order-sdk";
  //final String callBackUrl = "https://creworder.com/omni/api/webhook";
  final String packageName = "com.yehlo_User_app";
  final String merchantId = "M226DWVS5EFSO";
  final String saltKey = "0b577413-c778-48a7-b755-c4303c8c5839";
  //Merchant Salt Key - 0b577413-c778-48a7-b755-c4303c8c5839
  //Merchant ID  - M226DWVS5EFSO

  final String apiEndPoint = "/pg/v1/pay";
  final String saltIndex = "1";

  Future<void> initPhonePeSdk() async {
    try {
      bool isInitialized = await PhonePePaymentSdk.init('PRODUCTION', '', merchantId, true);
      if (!isInitialized) {
        throw Exception('PhonePe SDK initialization failed');
      }
    } catch (e) {
      print('Error initializing PhonePe SDK: $e');
    }
  }

  Future<Object> initiatePhonePePayment(
    double amount, String paymentMethod, String merchant_sdk_id, String contactNumber) async {
    int amountInPaisa = (amount * 100).toInt();
    final data = {
      "merchantId": merchantId,
      "merchantTransactionId": merchant_sdk_id,
      "merchantUserId": "MU${getRandomNumber()}",
      "amount": amountInPaisa,
      "callbackUrl": callBackUrl,
      "mobileNumber": contactNumber,
      "enableLogs": true,
      "paymentInstrument": {
        "type": "PAY_PAGE",
      }
    };
    String jsonString = jsonEncode(data);
    String base64Data = jsonString.toBase64;
    String dataToHash = base64Data + apiEndPoint + saltKey;
    String sha256Hash = generateSha256Hash(dataToHash);
    String body = base64Data;
    String checksum = "$sha256Hash###$saltIndex";
    String result = '';

    try {
      var response = await PhonePePaymentSdk.startTransaction(
          body, callBackUrl, checksum, packageName);
      if (response != null) {
        String status = response['status'].toString();
        String error = response['error'].toString();
        if (status == 'SUCCESS') {
          result = "Flow Completed - Status: Success!";
        } else {
          result = "Flow Completed - Status: $status and Error: $error";
        }
      } else {
        result = "Flow Incomplete";
      }
      return result;
    } catch (e) {
      print('Error initiating PhonePe payment: $e');
      return '';
    }
  }

  String generateSha256Hash(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  String getRandomNumber() {
    Random random = Random();
    String randomNumber = '';
    for (int i = 0; i < 15; i++) {
      randomNumber += random.nextInt(10).toString();
    }
    return randomNumber;
  }
}

extension StringExtensions on String {
  String get toBase64 {
    return base64.encode(utf8.encode(this));
  }
}
