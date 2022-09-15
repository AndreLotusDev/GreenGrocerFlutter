import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/pages/orders/controller/all_orders_controller.dart';

import 'component/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos"),
      ),
      body: GetBuilder<AllOrdersController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.getAllOrders();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, __) {
                return const SizedBox(
                  height: 10,
                );
              },
              separatorBuilder: (_, index) {
                return OrderTile(
                  orderModel: controller.getOrderModelByIndex(index),
                );
              },
              itemCount: controller.getNumberOfOrders() + 1,
            ),
          );
        },
      ),
    );
  }
}
