import 'package:get/get_connect/http/src/response/response.dart';
import 'package:yehlo_User/interfaces/repository_interface.dart';

abstract class LoyaltyRepositoryInterface extends RepositoryInterface {
  Future<Response> pointToWallet({int? point});
}