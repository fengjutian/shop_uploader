class ShopItem {
  final String id;
  final String name;
  final String address;
  final List<String> imagePaths;

  ShopItem({
    required this.id,
    required this.name,
    required this.address,
    required this.imagePaths,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'imagePaths': imagePaths,
    };
  }

  factory ShopItem.fromMap(Map<String, dynamic> map) {
    return ShopItem(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      imagePaths: List<String>.from(map['imagePaths']),
    );
  }
}
