import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:loja_virtual/src/models/item_model.dart';
import 'package:loja_virtual/src/pages/base/controller/navigation_controller.dart';
import 'package:loja_virtual/src/pages/cart/controller/cart_controller.dart';
import 'package:loja_virtual/src/pages/common_widgets/quantity_widget.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({Key? key}) : super(key: key);

  final ItemModel itemModel = Get.arguments;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final UtilsServices utilsServices = UtilsServices();

  int cartItemQuantity = 1;

  final navigationController = Get.find<NavigationController>();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      body: Stack(
        children: [
          //CONTEUDO
          Column(
            children: [
              Expanded(
                  child: Hero(
                      tag: widget.itemModel.imgUrl,
                      child: Image.network(widget.itemModel.imgUrl))),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade600,
                          offset: const Offset(0, 3))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        //NOME DO PRODUTO
                        Expanded(
                          child: Text(
                            widget.itemModel.itemName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold),
                          ),
                        ),

                        QuantityWidget(
                          suffixText: widget.itemModel.unit,
                          value: cartItemQuantity,
                          result: (quantity) {
                            setState(() {
                              cartItemQuantity = quantity;
                            });
                          },
                        )
                      ],
                    ),

                    //PRECO
                    Text(
                      utilsServices.priceToCurrency(widget.itemModel.price),
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.customSwatchColor),
                    ),

                    //DESCRICAO
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.itemModel.description,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ),
                    ),

                    //BOTAO
                    SizedBox(
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          Get.back();

                          cartController.addItemToCart(
                            item: widget.itemModel,
                            quantity: cartItemQuantity,
                          );

                          navigationController
                              .navigatePageView(NavigationTabs.cart);
                        },
                        label: const Text(
                          'Adicionar ao carrinho',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.shopping_cart_outlined),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),

          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios)),
            ),
          )
        ],
      ),
    );
  }
}
