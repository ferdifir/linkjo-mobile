import 'package:flutter/material.dart';
import 'package:linkjo/core/routes.dart';
import 'package:linkjo/model/menu.dart';
import 'package:linkjo/model/order_history.dart';
import 'package:linkjo/model/product.dart';
import 'package:linkjo/service/api_service.dart';
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
  List<String> categories = [];
  List<Product> productList = [];
  List<OrderHistory> orderHistoryList = [];

  void _addToOrder(Product menu) {
    setState(() {
      final index =
          orderList.indexWhere((item) => item.product!.id! == menu.id);
      if (index != -1) {
        orderList[index] =
            orderList[index].copyWith(quantity: orderList[index].quantity + 1);
      } else {
        var order = Menu(product: menu, quantity: 1);
        orderList.add(order);
      }
    });
    Helper.showSnackBar(context, '${menu.name} added to order list');
  }

  void _incrementQuantity(int menuName) {
    setState(() {
      final index =
          orderList.indexWhere((item) => item.product!.id == menuName);
      if (index != -1) {
        orderList[index] =
            orderList[index].copyWith(quantity: orderList[index].quantity + 1);
      }
    });
  }

  void _decrementQuantity(int menuName) {
    setState(() {
      final index =
          orderList.indexWhere((item) => item.product!.id == menuName);
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
    } else if (orderList.indexWhere((item) => item.product!.id == menuName) ==
        -1) {
      Helper.showSnackBar(context, '$menuName removed from order list');
    }
  }

  Future<void> _getProduct() async {
    final res = await _api.get("/products");
    if (res.success) {
      Map<String, dynamic> data = res.data!;
      categories = [];
      productList = [];
      data.forEach((key, value) {
        categories.add(key);
        value.forEach((e) => productList.add(Product.fromJson(e)));
      });
      Log.d(productList.first.categoryName);
      setState(() {});
    } else {
      Helper.showSnackBar(
        context,
        res.message!,
      );
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
        leading: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 2,
              color: Colors.grey.shade300,
            ),
            image: const DecorationImage(
              image: AssetImage('assets/logo.png'),
            ),
          ),
        ),
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
                          (prev, item) =>
                              prev + (item.product!.price * item.quantity),
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (categories.isEmpty) {
      return const Center(
        child: Text('Belum ada produk yang tersedia'),
      );
    }
    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [
          TabBar(
            tabs: categories.map((e) => Tab(text: e)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: categories
                  .map((e) => MenuList(
                        menuItems: productList
                            .where((element) => element.categoryName == e)
                            .toList(),
                        addToOrder: _addToOrder,
                        incrementQuantity: _incrementQuantity,
                        decrementQuantity: _decrementQuantity,
                        orderList: orderList,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
