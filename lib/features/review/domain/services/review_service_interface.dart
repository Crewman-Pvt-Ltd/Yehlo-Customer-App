import 'package:yehlo_User/common/models/response_model.dart';
import 'package:yehlo_User/features/review/domain/models/review_body_model.dart';
import 'package:yehlo_User/features/review/domain/models/review_model.dart';

abstract class ReviewServiceInterface {
  Future<List<ReviewModel>?> getStoreReviewList(String? storeID);
  Future<ResponseModel> submitReview(ReviewBodyModel reviewBody);
  Future<ResponseModel> submitDeliveryManReview(ReviewBodyModel reviewBody);
}