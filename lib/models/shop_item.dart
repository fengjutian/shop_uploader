class ShopItem {
  final String id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<String> imagePaths;
  final String? type;
  final String? description;

  ShopItem({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    required this.imagePaths,
    this.type,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'imagePaths': imagePaths,
      'type': type,
      'description': description,
    };
  }

  factory ShopItem.fromMap(Map<String, dynamic> map) {
    return ShopItem(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      imagePaths: List<String>.from(map['imagePaths']),
      type: map['type'],
      description: map['description'],
    );
  }
}
