import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foody/model/product_model.dart';


class BannerModel {
  final String title;
  final ProductModel product;

  BannerModel({required this.title, required this.product});

  factory BannerModel.fromJson(
      {required Map<String, dynamic> data, required Map? dataProduct}) {
    return BannerModel(
        title: data["title"], product: ProductModel.fromJson(dataProduct,false));
  }
}
