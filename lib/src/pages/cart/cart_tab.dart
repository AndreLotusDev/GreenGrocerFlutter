import 'package:flutter/material.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:loja_virtual/src/models/cart_item_model.dart';
import 'package:loja_virtual/src/pages/cart/components/cart_tile.dart';
import 'package:loja_virtual/src/pages/common_widgets/payment_dialog.dart';
import 'package:loja_virtual/src/services/utils_services.dart';
import 'package:loja_virtual/src/config/app_data.dart' as APP_DATA;

class CartTab extends StatefulWidget {
  CartTab({Key? key}) : super(key: key);

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final UtilsServices utilsServices = UtilsServices();

  void removeItemFromCart(CartItemModel cartItem) {
    setState(() {
      APP_DATA.cartItems.remove(cartItem);
    });
  }

  double cartTotalPrice() {
    double total = 0;

    for (var item in APP_DATA.cartItems) {
      total += item.totalPrice();
    }

    return total;
  }

  Future<bool?> showOrderConfirmation() {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Confirmação"),
            content: const Text("Deseja realmente concluir o pedido?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Não")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Sim"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: APP_DATA.cartItems.length,
              itemBuilder: (_, index) {
                return CartTile(
                  cartItemModel: APP_DATA.cartItems[index],
                  removeItem: removeItemFromCart,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3,
                      spreadRadius: 2)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total geral',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  utilsServices.priceToCurrency(cartTotalPrice()),
                  style: TextStyle(
                      fontSize: 23,
                      color: CustomColors.customSwatchColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: CustomColors.customSwatchColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18))),
                      onPressed: () async {
                        bool? result = await showOrderConfirmation();

                        if (result ?? false) {
                          utilsServices.showToast(message: 'Pedido confirmado');

                          showDialog(
                            context: context,
                            builder: (_) {
                              return PaymentDialog(
                                order: APP_DATA.orders.first,
                              );
                            },
                          );
                        } else {
                          utilsServices.showToast(message: 'Pedido cancelado');
                        }
                      },
                      child: const Text(
                        'Concluir pedido',
                        style: TextStyle(fontSize: 18),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
