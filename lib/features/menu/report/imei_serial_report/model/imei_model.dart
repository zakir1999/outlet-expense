
class ImeiSerialRecord {
  final String productName;
  final String? brandName;
  final String? imei;
  final int? inStock;
  final String? vendorName;
  final String? customerName;
  final num? purchasePrice;
  final num? salePrice;
  final String? purchaseInvoice;
  final String? saleInvoice;
  final String? date;
  final String? productCondition;
  final String? storage;
  final String? color;
  final String? region;
  final String? batteryLife;
  final String? carrierName;
  final String? exporterName;

  ImeiSerialRecord({
    required this.productName,
    this.brandName,
    this.imei,
    this.inStock,
    this.vendorName,
    this.customerName,
    this.purchasePrice,
    this.salePrice,
    this.purchaseInvoice,
    this.saleInvoice,
    this.date,
    this.productCondition,
    this.storage,
    this.color,
    this.region,
    this.batteryLife,
    this.carrierName,
    this.exporterName,
  });

  factory ImeiSerialRecord.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }
    return ImeiSerialRecord(
      productName: json['product_name']?.toString() ?? '',
      brandName: json['brand_name'] as String?,
      imei: json['imei'] as String?,
      inStock: parseInt(json['in_stock']),
      vendorName: json['vendor_name'] as String?,
      customerName: json['customer_name'] as String?,
      purchasePrice: json['purchase_price'] ?? 0,
      salePrice: json['sale_price'] ?? 0,
      purchaseInvoice: json['purchase_invoice'] as String?,
      saleInvoice: json['sale_invoice'] as String?,
      date: json['date'] as String?,
      productCondition: json['product_condition'] as String?,
      storage: json['storage'] as String?,
      color: json['color'] as String?,
      region: json['region'] as String?,
      batteryLife: json['battery_life'] as String?,
      carrierName: json['carrier_name'] as String?,
      exporterName: json['exporter_name'] as String?,
    );
  }
}
