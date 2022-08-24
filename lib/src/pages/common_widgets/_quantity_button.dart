import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.onPressed
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(

        borderRadius: BorderRadius.circular(50),

        onTap: onPressed,
        child: Ink(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}