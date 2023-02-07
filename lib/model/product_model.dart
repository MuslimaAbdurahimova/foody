class ProductModel {
  final String? name;
  final String? desc;
  final String? image;
  final num? price;
   bool isLike;
  final String? category;
  final String? type;

  ProductModel(
      {required this.name,
      required this.desc,
      required this.image,
      required this.price,
      required this.category,
      required this.isLike,
      required this.type});

  factory ProductModel.fromJson(Map? data,bool? isLike) {
    return ProductModel(
      name: data?["name"],
      desc: data?["desc"],
      image: data?["image"],
      price: data?["price"],
      category: data?["category"],
      type: data?["type"],
      isLike: isLike ?? false,
    );
  }

  toJson() {
    return {
      "name": name,
      "desc": desc,
      "image": image,
      "price": price,
      "category": category,
      "type": type
    };
  }
}
