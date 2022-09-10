import 'package:flutter/material.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile(
      {Key? key,
      required this.category,
      required this.isSelected,
      required this.externalCall})
      : super(key: key);

  final String category;
  final bool isSelected;
  final VoidCallback externalCall;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: externalCall,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected
                  ? CustomColors.customSwatchColor
                  : Colors.transparent),
          child: Text(
            category,
            style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : CustomColors.customContrastColor,
                fontSize: isSelected ? 16 : 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
