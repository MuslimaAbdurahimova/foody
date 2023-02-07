class CategoryModel {
  final String? name;
  final String? image;

  CategoryModel({required this.name, required this.image});

  factory CategoryModel.fromJson(Map data) {
    return CategoryModel(name: data["name"], image: data["image"]);
  }
}
