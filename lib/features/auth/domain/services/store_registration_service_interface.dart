import 'package:image_picker/image_picker.dart';
import 'package:yehlo_User/common/models/module_model.dart';
import 'package:yehlo_User/features/location/domain/models/zone_data_model.dart';
import 'package:yehlo_User/features/auth/domain/models/store_body_model.dart';

abstract class StoreRegistrationServiceInterface{
  Future<List<ZoneDataModel>?> getZoneList();
  int? prepareSelectedZoneIndex(List<int>? zoneIds, List<ZoneDataModel>? zoneList);
  Future<List<ModuleModel>?> getModules(int? zoneId);
  Future<void> registerStore(StoreBodyModel store, XFile? logo, XFile? cover);
}