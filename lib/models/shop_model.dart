class ShopModel {
  final String name;
  final String address;
  final List<String> images;

  ShopModel({required this.name, required this.address, required this.images});

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      name: json['name'],
      address: json['address'],
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
