import 'package:flutter/material.dart';
import 'package:linkjo/model/menu.dart';
import 'package:linkjo/utils/helper.dart';
import 'package:linkjo/widget/app_button.dart';

class OrderList extends StatefulWidget {
  const OrderList({
    super.key,
    required this.orderList,
    required this.removeFromOrder,
    required this.onCheckout,
  });

  final List<Menu> orderList;
  final Function(int) removeFromOrder;
  final Function onCheckout;

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  String paymentMethod = 'cash';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Order List',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            trailing: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.orderList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.orderList[index].product!.name),
                  subtitle: Text(
                    'Rp ${Helper.thousandSeparator(widget.orderList[index].product!.price)} x ${widget.orderList[index].quantity}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.removeFromOrder(index);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              'Total Price',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Text(
              'Rp ${Helper.thousandSeparator(widget.orderList.fold<int>(
                0,
                (prev, item) =>
                    prev + (item.product!.price * item.quantity).round(),
              ))}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio(
                  value: 'cash',
                  groupValue: paymentMethod,
                  onChanged: (_) {
                    setState(() {
                      paymentMethod = 'cash';
                    });
                  },
                ),
                const Text('Cash'),
                Radio(
                  value: 'qris',
                  groupValue: paymentMethod,
                  onChanged: (_) {
                    setState(() {
                      paymentMethod = 'qris';
                    });
                  },
                ),
                const Text('QRIS'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
              onPressed: () {
                widget.orderList.clear();
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text(
                'Checkout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
