import 'package:flutter/material.dart';
import 'package:loja_virtual/src/config/app_data.dart' as APP_DATA;
import 'package:loja_virtual/src/pages/orders/component/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return const SizedBox(
            height: 10,
          );
        },
        separatorBuilder: (_, index) {
          return OrderTile(
            orderModel: APP_DATA.orders[index],
          );
        },
        itemCount: APP_DATA.orders.length + 1,
      ),
    );
  }
}
