import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:loja_virtual/src/models/item_model.dart';
import 'package:loja_virtual/src/pages/cart/controller/cart_controller.dart';
import 'package:loja_virtual/src/pages/product/product_screen.dart';
import 'package:loja_virtual/src/pages_routes/app_pages.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

class ItemTile extends StatefulWidget {
  ItemTile({Key? key, required this.item, required this.cartAnimationMethod})
      : super(key: key);

  ItemModel item;

  final void Function(GlobalKey) cartAnimationMethod;

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final UtilsServices utilsServices = UtilsServices();

  final GlobalKey imageGk = GlobalKey();

  final cartController = Get.find<CartController>();

  IconData tileIconToSwitchOnBuy = Icons.add_shopping_cart_outlined;

  Future<void> switchIcon() async {
    setState(() {
      tileIconToSwitchOnBuy = Icons.check;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      tileIconToSwitchOnBuy = Icons.add_shopping_cart_outlined;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(PagesRoutes.productRoute, arguments: widget.item);
          },
          child: Card(
            elevation: 3,
            shadowColor: Colors.grey.shade300,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Hero(
                      tag: widget.item.imgUrl,
                      child: Image.network(
                        widget.item.imgUrl,
                        key: imageGk,
                      ),
                    ),
                  ),
                  Text(
                    widget.item.itemName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        utilsServices.priceToCurrency(widget.item.price),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.customSwatchColor),
                      ),
                      Text(
                        '/${widget.item.unit}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: 4,
            right: 4,
            child: ClipRect(
              child: Material(
                child: InkWell(
                  onTap: () {
                    switchIcon();

                    cartController.addItemToCart(item: widget.item);

                    widget.cartAnimationMethod(imageGk);
                  },
                  child: Ink(
                    width: 35,
                    height: 40,
                    decoration:
                        BoxDecoration(color: CustomColors.customSwatchColor),
                    child: Icon(
                      tileIconToSwitchOnBuy,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
