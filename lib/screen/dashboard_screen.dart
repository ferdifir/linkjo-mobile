import 'package:flutter/material.dart';
import 'package:linkjo/core/routes.dart';
import 'package:linkjo/model/menu.dart';
import 'package:linkjo/model/order_history.dart';
import 'package:linkjo/model/product.dart';
import 'package:linkjo/service/api_service.dart';
import 'package:linkjo/utils/dummy.dart';
import 'package:linkjo/utils/helper.dart';
import 'package:linkjo/utils/log.dart';
import 'package:linkjo/widget/menu_list.dart';
import 'package:linkjo/widget/order_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _api = ApiService();
  List<Menu> orderList = [];
  List<Product> productList = [];
  List<OrderHistory> orderHistoryList = [];

  void _addToOrder(Menu menu) {
    setState(() {
      final index = orderList.indexWhere((item) => item.name == menu.name);
      if (index != -1) {
        orderList[index] =
            orderList[index].copyWith(quantity: orderList[index].quantity + 1);
      } else {
        orderList.add(menu.copyWith(quantity: 1));
      }
    });
    Helper.showSnackBar(context, '${menu.name} added to order list');
  }

  void _incrementQuantity(String menuName) {
    setState(() {
      final index = orderList.indexWhere((item) => item.name == menuName);
      if (index != -1) {
        orderList[index] =
            orderList[index].copyWith(quantity: orderList[index].quantity + 1);
      }
    });
    Helper.showSnackBar(context, 'Quantity of $menuName increased');
  }

  void _decrementQuantity(String menuName) {
    setState(() {
      final index = orderList.indexWhere((item) => item.name == menuName);
      if (index != -1) {
        if (orderList[index].quantity > 1) {
          orderList[index] = orderList[index]
              .copyWith(quantity: orderList[index].quantity - 1);
        } else {
          orderList.removeAt(index);
        }
      }
    });
    if (orderList.isEmpty) {
      Helper.showSnackBar(context, 'Order list is empty');
    } else if (orderList.indexWhere((item) => item.name == menuName) == -1) {
      Helper.showSnackBar(context, '$menuName removed from order list');
    } else {
      Helper.showSnackBar(context, 'Quantity of $menuName decreased');
    }
  }

  void _getProduct() async {
    Log.d("Get product");
    final res = await _api.get("/products");
    if (res.success) {
      setState(() {
        productList = res.data.map((e) => Product.fromJson(e)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkJo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.statistic,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.orderHistory,
              );
            },
          ),
          IconButton(
            onPressed: () {
              if (orderList.isNotEmpty) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return OrderList(
                      orderList: orderList,
                      removeFromOrder: (index) {
                        setState(() {
                          orderList.removeAt(index);
                        });
                        if (orderList.isEmpty) {
                          Navigator.pop(context);
                        }
                      },
                      onCheckout: () {
                        var now = DateTime.now();
                        var total = orderList.fold<int>(
                          0,
                          (prev, item) => prev + (item.price * item.quantity),
                        );
                        var data = OrderHistory(
                          orderNumber: now.millisecondsSinceEpoch.toString(),
                          items: orderList,
                          totalPrice: total.toDouble(),
                          paymentMethod: 'cash',
                          status: 'pending',
                          date: now,
                        );
                        orderHistoryList.add(data);
                      },
                    );
                  },
                );
              } else {
                Helper.showSnackBar(context, 'Order list is empty');
              }
            },
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_rounded, size: 30),
                if (orderList.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 8,
                      child: Text(
                        orderList
                            .fold<int>(0, (prev, item) => prev + item.quantity)
                            .toString(),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Bakso'),
                Tab(text: 'Mie Ayam'),
                Tab(text: 'Minuman'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MenuList(
                    menuItems: baksoList,
                    addToOrder: _addToOrder,
                    incrementQuantity: _incrementQuantity,
                    decrementQuantity: _decrementQuantity,
                    orderList: orderList,
                  ),
                  MenuList(
                    menuItems: mieAyamList,
                    addToOrder: _addToOrder,
                    incrementQuantity: _incrementQuantity,
                    decrementQuantity: _decrementQuantity,
                    orderList: orderList,
                  ),
                  MenuList(
                    menuItems: minumanList,
                    addToOrder: _addToOrder,
                    incrementQuantity: _incrementQuantity,
                    decrementQuantity: _decrementQuantity,
                    orderList: orderList,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
