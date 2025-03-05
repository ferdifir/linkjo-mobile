import 'package:linkjo/model/product.dart';

class Menu {
  Product? product;
  int quantity;

  Menu({
    this.product,
    this.quantity = 0,
  });

  Menu copyWith({
    Product? product,
    int? quantity,
  }) {
    return Menu(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
