import 'package:get/get.dart';
import 'package:yehlo_User/util/html_type.dart';

abstract class HtmlServiceInterface{
  Future<Response> getHtmlText(HtmlType htmlType);
}