import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/config/app_data.dart';
import 'package:loja_virtual/src/models/cart_item_model.dart';
import 'package:loja_virtual/src/models/order_model.dart';
import 'package:loja_virtual/src/pages/common_widgets/payment_dialog.dart';
import 'package:loja_virtual/src/pages/orders/controller/order_controller.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

import 'order_status_widget.dart';

class OrderTile extends StatefulWidget {
  const OrderTile({Key? key, required this.orderModel}) : super(key: key);

  final OrderModel orderModel;

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: GetBuilder<OrderController>(
          init: OrderController(widget.orderModel),
          global: false,
          builder: (controller) {
            return ExpansionTile(
              onExpansionChanged: (value) {
                if (value && widget.orderModel.items.isEmpty) {
                  controller.getOrderItems();
                }
              },
              //initiallyExpanded: widget.orderModel.status == 'pending_payment',
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pedido ${widget.orderModel.id}'),
                  Text(
                    utilsServices
                        .formatDateTime(widget.orderModel.createdDateTime),
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              children: controller.isLoading
                  ? [
                      Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    ]
                  : [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            //LISTA DE PRODUTO
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 150,
                                child: ListView(
                                  children:
                                      widget.orderModel.items.map((order) {
                                    return _OrderItemWidget(order: order);
                                  }).toList(),
                                ),
                              ),
                            ),

                            //DIVISAO
                            VerticalDivider(
                              color: Colors.grey.shade300,
                              thickness: 2,
                              width: 8,
                            ),

                            //WIDGET STATUS
                            Expanded(
                              flex: 2,
                              child: OrderStatusWidget(
                                  status: widget.orderModel.status,
                                  isOverdue: widget.orderModel.overdueDt
                                      .isBefore(DateTime.now())),
                            )
                          ],
                        ),
                      ),

                      //TOTAL
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(fontSize: 16),
                          children: [
                            const TextSpan(
                              text: 'Total ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: utilsServices
                                  .priceToCurrency(widget.orderModel.total),
                            ),
                          ],
                        ),
                      ),

                      //BOTAO DE EFETUAR PAGAMENTO
                      Visibility(
                        visible:
                            widget.orderModel.status == 'pending_payment' &&
                                !widget.orderModel.isOverDue,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return PaymentDialog(
                                  order: widget.orderModel,
                                );
                              },
                            );
                          },
                          icon: Image.asset(
                            'assets/app_images/pix.png',
                            height: 18,
                          ),
                          label: const Text('Ver QR code PIX'),
                        ),
                      ),
                    ],
            );
          },
        ),
      ),
    );
  }
}

class _OrderItemWidget extends StatelessWidget {
  _OrderItemWidget({Key? key, required this.order}) : super(key: key);

  final CartItemModel order;
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '${order.quantity} ${order.item.unit} ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(" ${order.item.itemName}"),
          ),
          Text(utilsServices.priceToCurrency(order.totalPrice()))
        ],
      ),
    );
  }
}
