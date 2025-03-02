class Product {
//   type Product struct {
// 	ID            uint    `gorm:"primaryKey;autoIncrement"`
// 	TenantID      uint    `gorm:"not null;index"`
// 	CategoryID    *uint   `gorm:"index"`
// 	Name          string  `gorm:"type:varchar(255);not null"`
// 	SKU           string  `gorm:"type:varchar(50);unique"`
// 	Barcode       string  `gorm:"type:varchar(100);unique"`
// 	Price         float64 `gorm:"not null"`
// 	CostPrice     *float64
// 	Discount      float64   `gorm:"default:0"`
// 	Stock         int       `gorm:"not null;default:0"`
// 	MinStockAlert int       `gorm:"default:0"`
// 	Unit          string    `gorm:"type:varchar(50);not null;default:'pcs'"`
// 	SupplierID    *uint     `gorm:"index"`
// 	Image         string    `gorm:"type:text"`
// 	Description   string    `gorm:"type:text"`
// 	IsActive      bool      `gorm:"default:true"`
// 	CreatedAt     time.Time `gorm:"autoCreateTime"`
// 	UpdatedAt     time.Time `gorm:"autoUpdateTime"`
// }
  int? id;
  final int tenantId;
  final int categoryId;
  final String name;
  final String sku;
  final String barcode;
  final double price;
  final double? costPrice;
  final double discount;
  final int stock;
  final int minStockAlert;
  final String unit;
  final int? supplierId;
  final String image;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

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
}
