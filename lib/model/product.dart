class Product {
  int? id;
  final int tenantId;
  final int categoryId;
  final String name;
  final String? sku;
  final String? barcode;
  final int price;
  final double? costPrice;
  final int discount;
  final int stock;
  final int minStockAlert;
  final String unit;
  final int? supplierId;
  final String image;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? categoryName;

  Product({
    this.id,
    required this.tenantId,
    required this.categoryId,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.price,
    this.costPrice,
    required this.discount,
    required this.stock,
    required this.minStockAlert,
    required this.unit,
    this.supplierId,
    required this.image,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ID'],
      tenantId: json['TenantID'],
      categoryId: json['CategoryID'],
      name: json['Name'],
      sku: json['SKU'],
      barcode: json['Barcode'],
      price: json['Price'],
      costPrice: json['CostPrice'],
      discount: json['Discount'],
      stock: json['Stock'],
      minStockAlert: json['MinStockAlert'],
      unit: json['Unit'],
      supplierId: json['SupplierID'],
      image: json['Image'],
      description: json['Description'],
      isActive: json['IsActive'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'TenantID': tenantId,
      'CategoryID': categoryId,
      'Name': name,
      'SKU': sku,
      'Barcode': barcode,
      'Price': price,
      'CostPrice': costPrice,
      'Discount': discount,
      'Stock': stock,
      'MinStockAlert': minStockAlert,
      'Unit': unit,
      'SupplierID': supplierId,
      'Image': image,
      'Description': description,
      'IsActive': isActive,
    };
  }

  Product copyWith({
    int? id,
    int? tenantId,
    int? categoryId,
    String? name,
    String? sku,
    String? barcode,
    int? price,
    double? costPrice,
    int? discount,
    int? stock,
    int? minStockAlert,
    String? unit,
    int? supplierId,
    String? image,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? categoryName,
  }) {
    return Product(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      discount: discount ?? this.discount,
      stock: stock ?? this.stock,
      minStockAlert: minStockAlert ?? this.minStockAlert,
      unit: unit ?? this.unit,
      supplierId: supplierId ?? this.supplierId,
      image: image ?? this.image,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
