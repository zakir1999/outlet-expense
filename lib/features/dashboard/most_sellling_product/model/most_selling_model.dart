// class MostSellingProduct {
//   final String name;
//   final String category;
//   final String subCategory;
//   final String brand;
//   final double price;
//   final int stock;
//   final String unit;
//   final double wholeSalePrice;
//   final int discount;
//   final String imageUrl;
//
//   MostSellingProduct({
//     required this.name,
//     required this.category,
//     required this.subCategory,
//     required this.brand,
//     required this.price,
//     required this.stock,
//     required this.unit,
//     required this.wholeSalePrice,
//     required this.discount,
//     required this.imageUrl,
//   });
//
//   factory MostSellingProduct.fromJson(Map<String, dynamic> json) {
//     return MostSellingProduct(
//       name: json['name'] ?? '',
//       category: json['category_id'] ?? '',
//       subCategory: json['sub_category_id'] ?? '',
//       brand: json['brand'] ?? '',
//       price: double.tryParse(json['purchase_price'].toString()) ?? 0,
//       stock: json['current_stock'] ?? 0,
//       unit: json['unit'] ?? '',
//       wholeSalePrice:
//       double.tryParse(json['wholesale_price'].toString()) ?? 0,
//       discount: json['discount'] ?? 0,
//       imageUrl: json['image_path'] ?? '',
//     );
//   }
// }
class MostSellingProduct {
  final String name;
  final String category;
  final String subCategory;
  final String brand;
  final double price;
  final int stock;
  final String unit;
  final double wholeSalePrice;
  final int discount;
  final String imageUrl;

  MostSellingProduct({
    required this.name,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.price,
    required this.stock,
    required this.unit,
    required this.wholeSalePrice,
    required this.discount,
    required this.imageUrl,
  });

  factory MostSellingProduct.fromJson(Map<String, dynamic> json) {
    // safe string conversion helper
    String safeToString(dynamic value) => value?.toString() ?? '';

    return MostSellingProduct(
      name: safeToString(json['name']),
      category: safeToString(json['category']?['name']),
      subCategory: safeToString(json['sub_category']?['name']),
      brand: safeToString(json['brands']?['name']),
      price: (json['retails_price'] != null)
          ? double.tryParse(json['retails_price'].toString()) ?? 0
          : 0,
      stock: json['current_stock'] is int
          ? json['current_stock']
          : int.tryParse(json['current_stock'].toString()) ?? 0,
      unit: safeToString(json['unit']?['name']),
      wholeSalePrice: (json['wholesale_price'] != null)
          ? double.tryParse(json['wholesale_price'].toString()) ?? 0
          : 0,
      discount: json['discount'] is int
          ? json['discount']
          : int.tryParse(json['discount'].toString()) ?? 0,
      imageUrl: safeToString(json['image_path']),
    );
  }
}
