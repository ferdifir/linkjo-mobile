class Menu {
  final String name;
  String? image;
  final int price;
  int quantity;

  Menu({
    required this.name,
    this.image,
    required this.price,
    this.quantity = 0,
  });

  Menu copyWith({
    String? name,
    String? image,
    int? price,
    int? quantity,
  }) {
    return Menu(
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
