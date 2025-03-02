import 'package:linkjo/model/menu.dart';

class OrderHistory {
  final String orderNumber;
  final List<Menu> items;
  final double totalPrice;
  final String paymentMethod;
  final String status;
  final DateTime date;

  OrderHistory({
    required this.orderNumber,
    required this.items,
    required this.totalPrice,
    required this.paymentMethod,
    required this.status,
    required this.date,
  });
}
