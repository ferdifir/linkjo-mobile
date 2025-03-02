import 'package:flutter/material.dart';
import 'package:linkjo/model/menu.dart';
import 'package:linkjo/utils/helper.dart';

class MenuList extends StatefulWidget {
  const MenuList({
    super.key,
    required this.menuItems,
    required this.addToOrder,
    required this.incrementQuantity,
    required this.decrementQuantity,
    required this.orderList,
  });

  final List<Menu> menuItems;
  final Function(Menu) addToOrder;
  final Function(String) incrementQuantity;
  final Function(String) decrementQuantity;
  final List<Menu> orderList;

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: widget.menuItems.length,
      itemBuilder: (context, index) {
        final menu = widget.menuItems[index];
        final orderIndex =
            widget.orderList.indexWhere((item) => item.name == menu.name);
        final quantity =
            orderIndex != -1 ? widget.orderList[orderIndex].quantity : 0;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(menu.image!, height: 100),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Rp ${Helper.thousandSeparator(menu.price)}",
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.005),
                quantity == 0
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.addToOrder(menu);
                          });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_checkout_sharp),
                            SizedBox(width: 5),
                            Text('Tambah'),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              widget.decrementQuantity(menu.name);
                              setState(() {});
                            },
                          ),
                          Text(quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              widget.incrementQuantity(menu.name);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
