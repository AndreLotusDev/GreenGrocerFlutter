import 'package:flutter/material.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:loja_virtual/src/models/cart_item_model.dart';
import 'package:loja_virtual/src/pages/common_widgets/quantity_widget.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

class CartTile extends StatefulWidget {
  const CartTile(
      {Key? key, required this.cartItemModel, required this.removeItem})
      : super(key: key);

  final CartItemModel cartItemModel;
  final Function(CartItemModel cartItem) removeItem;

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        //IMAGEM
        leading: Image.asset(
          widget.cartItemModel.item.imgUrl,
          height: 60,
          width: 60,
        ),

        //TITULO
        title: Text(
          widget.cartItemModel.item.itemName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),

        //TOTAL
        subtitle: Text(
          utilsServices.priceToCurrency(widget.cartItemModel.totalPrice()),
          style: TextStyle(
              color: CustomColors.customSwatchColor,
              fontWeight: FontWeight.bold),
        ),

        //BOTA QTD
        trailing: QuantityWidget(
          suffixText: widget.cartItemModel.item.unit,
          value: widget.cartItemModel.quantity,
          result: (quantity) {
            setState(() {
              widget.cartItemModel.quantity = quantity;

              utilsServices.showToast(
                  message: 'Removido com sucesso do carrinho');

              if (quantity == 0) {
                widget.removeItem(widget.cartItemModel);
              }
            });
          },
          isRemovable: true,
        ),
      ),
    );
  }
}
