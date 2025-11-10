class ProductionStockItem {

  final String name;
  final double purchasePrice;
  final int currentStock;

  ProductionStockItem({
    required this.name,
    required this.purchasePrice,
    required this.currentStock,

  });

  factory ProductionStockItem.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    return ProductionStockItem(
      name: json['name']?.toString() ?? '',
      purchasePrice: parseDouble(json['purchase_price']?? 0),
      currentStock: parseInt(json['current_stock'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'purchase_price': purchasePrice,
    'current_stock': currentStock
  };
}

class ProductionStockResponse {
  final List<ProductionStockItem> items;

  ProductionStockResponse({required this.items});

  factory ProductionStockResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    final items = data.map((e) {
      if (e is Map<String, dynamic>) return ProductionStockItem.fromJson(e);
      return ProductionStockItem.fromJson(Map<String, dynamic>.from(e));
    }).toList();
    return ProductionStockResponse(items: items);
  }
}
