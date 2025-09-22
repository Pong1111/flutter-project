class ShoeModel {
  final String id;
  final String name;
  final String brand;
  final String colorway;
  final double price;
  final String? description;
  final List<String> images;
  final String sku;
  final bool inStock;

  ShoeModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.colorway,
    required this.price,
    this.description,
    required this.images,
    required this.sku,
    required this.inStock,
  });

  factory ShoeModel.fromJson(Map<String, dynamic> json) {
    return ShoeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      colorway: json['colorway']?.toString() ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description']?.toString(),
      images: List<String>.from(json['images'] ?? []),
      sku: json['sku']?.toString() ?? '',
      inStock: json['inStock'] ?? true,
    );
  }
}