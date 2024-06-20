import 'package:yehlo_User/interfaces/repository_interface.dart';
import 'package:yehlo_User/util/html_type.dart';

abstract class HtmlRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getHtmlText(HtmlType htmlType);
}