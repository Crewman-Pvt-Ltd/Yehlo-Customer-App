import 'package:yehlo_User/api/api_client.dart';
import 'package:yehlo_User/features/auth/domain/models/delivery_man_body.dart';
import 'package:yehlo_User/interfaces/repository_interface.dart';

abstract class DeliverymanRegistrationRepositoryInterface extends RepositoryInterface{
  @override
  Future getList({int? offset, int? zoneId, bool isZone = true, bool isVehicle = false});
  Future<bool> registerDeliveryMan(DeliveryManBody deliveryManBody, List<MultipartBody> multiParts);
}