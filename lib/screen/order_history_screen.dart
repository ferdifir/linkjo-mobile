import 'package:flutter/material.dart';
import 'package:linkjo/model/order_history.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final List<OrderHistory> orderHistoryList = [
    OrderHistory(
      orderNumber: '123456',
      items: [],
      totalPrice: 100000,
      paymentMethod: 'cash',
      status: 'completed',
      date: DateTime.now(),
    ),
    OrderHistory(
      orderNumber: '123457',
      items: [],
      totalPrice: 200000,
      paymentMethod: 'cash',
      status: 'pending',
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Order')),
      body: orderHistoryList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada riwayat order",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: orderHistoryList.length,
              itemBuilder: (context, index) {
                final order = orderHistoryList[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: order.status == 'completed'
                          ? Colors.green
                          : Colors.orange,
                      child: Icon(
                        order.status == 'completed'
                            ? Icons.check_circle
                            : Icons.pending,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      "Order #${order.orderNumber}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Total: Rp ${order.totalPrice.toStringAsFixed(0)}"),
                        Text("Metode: ${order.paymentMethod.toUpperCase()}"),
                        Text("Tanggal: ${order.date.toLocal()}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
    );
  }
}
