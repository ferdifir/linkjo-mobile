import 'package:flutter/material.dart';
import 'package:linkjo/core/routes.dart';
import 'package:linkjo/service/hive_service.dart';
import 'package:linkjo/utils/hive_key.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.addProduct,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              HiveService.deleteData(HiveKey.token);
              Navigator.pushReplacementNamed(
                context,
                Routes.login,
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Total Order'),
                  subtitle: Text('100'),
                ),
                ListTile(
                  title: Text('Total Revenue'),
                  subtitle: Text('Rp 1.000.000'),
                ),
                ListTile(
                  title: Text('Most Payment Method'),
                  subtitle: Text('Cash 80%, QRIS 20%'),
                ),
                ListTile(
                  title: Text('Average Transaction'),
                  subtitle: Text('Rp 10.000'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
