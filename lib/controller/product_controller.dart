import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';


class ProductController extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List listOfCategory = [];
  List listOfType = ["KG", "PC"];
  int selectCategoryIndex = 0;
  int selectTypeIndex = 0;
  bool isLoading = true;
  bool isSaveLoading = false;
  QuerySnapshot? res;

  getCategory() async {
    isLoading = true;
    notifyListeners();
    res = await firestore.collection("category").get();
    listOfCategory.clear();
    res?.docs.forEach((element) {
      listOfCategory.add(element["name"]);
    });
    isLoading = false;
    notifyListeners();
  }

  setCategory(String category) {
    selectCategoryIndex = listOfCategory.indexOf(category);
  }

  setType(String type) {
    selectTypeIndex = listOfType.indexOf(type);
  }

  createProduct(
      {required String name,
      required String desc,
      required String price}) async {
    isSaveLoading = true;
    notifyListeners();
    await firestore.collection("products").add(ProductModel(
            name: name,
            desc: desc,
            image: "",
            price: double.tryParse(price) ?? 0,
            category: res?.docs[selectCategoryIndex].id,
            type: listOfType[selectTypeIndex], isLike: false)
        .toJson());
    isSaveLoading = false;
    notifyListeners();
  }

  addCategory({required String name,required VoidCallback onSuccess}) async {
    await firestore.collection("category").add({"name": name});
    onSuccess();
  }
}
