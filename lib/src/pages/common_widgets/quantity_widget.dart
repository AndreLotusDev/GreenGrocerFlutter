import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';

import '_quantity_button.dart';

class QuantityWidget extends StatefulWidget {
  const QuantityWidget({
    Key? key,
    required this.suffixText,
    required this.value,
    required this.result,
    this.isRemovable = false
  }) : super(key: key);

  final int value;
  final String suffixText;
  final Function(int quantity) result;
  final bool isRemovable;

  @override
  State<QuantityWidget> createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<QuantityWidget> {
  @override
  Widget build(BuildContext context) {

    bool shouldRemove = !widget.isRemovable || widget.value > 1;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 2
          )
        ]
      ),

      child: Row (
        mainAxisSize: MainAxisSize.min,
        children: [
          QuantityButton(
            icon:  shouldRemove ? Icons.remove : Icons.delete_forever,
            color: shouldRemove ? Colors.grey : Colors.red,
            onPressed: () {

              if(widget.value == 1 && !widget.isRemovable) {
                return;
              }

              int resultCount = widget.value -1;

              widget.result(resultCount);

            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '${widget.value}${widget.suffixText}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
            ),
          ),

          QuantityButton(
            icon: Icons.add,
            color: CustomColors.customSwatchColor,
            onPressed: () {

              int resultCount = widget.value + 1;

              widget.result(resultCount);

            },
          ),
        ],
      ),
    );
  }
}


