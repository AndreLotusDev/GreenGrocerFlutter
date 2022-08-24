import 'package:flutter/material.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';

class OrderStatusWidget extends StatelessWidget {
  OrderStatusWidget({
    Key? key,
    required this.status,
    required this.isOverdue,
  }) : super(key: key);

  final String status;
  final bool isOverdue;

  final Map<String, int> allStatus = <String, int>{
    'pending_payment': 0,
    'refunded': 1,
    'paid': 2,
    'preparing_purchase': 3,
    'shipping': 4,
    'delivered': 5
  };

  int get currentStatus => allStatus[status] ?? 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StatusDot(isActive: true, textToDisplay: 'Pedido confirmado'),
        const _CustomDivider(),
        if (currentStatus == 1) ...[
          const _StatusDot(
            isActive: true,
            textToDisplay: 'Pix Estornado',
            backGroundColor: Colors.orange,
          ),
        ] else if (isOverdue) ...[
          const _StatusDot(
            isActive: true,
            textToDisplay: 'Pagamento do pix vencido',
            backGroundColor: Colors.red,
          ),
        ] else ...[
          _StatusDot(
            isActive: currentStatus >= 2,
            textToDisplay: 'Pagamento',
          ),
          const _CustomDivider(),
          _StatusDot(
            isActive: currentStatus >= 3,
            textToDisplay: 'Preparando',
          ),
          const _CustomDivider(),
          _StatusDot(
            isActive: currentStatus >= 4,
            textToDisplay: 'Envio',
          ),
          const _CustomDivider(),
          _StatusDot(
            isActive: currentStatus == 5,
            textToDisplay: 'Entregue',
          ),
        ]
      ],
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({
    Key? key,
    required this.isActive,
    required this.textToDisplay,
    this.backGroundColor,
  }) : super(key: key);

  final bool isActive;
  final String textToDisplay;
  final Color? backGroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //DOT
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: backGroundColor ?? CustomColors.customSwatchColor),
            color: isActive
                ? backGroundColor ?? CustomColors.customSwatchColor
                : Colors.transparent,
          ),
          child: isActive
              ? const Icon(
                  Icons.check,
                  size: 13,
                  color: Colors.white,
                )
              : const SizedBox.shrink(),
        ),

        //ESPACAMENTo
        const SizedBox(
          width: 5,
        ),

        //TEXTO
        Expanded(
          child: Text(
            textToDisplay,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      height: 10,
      width: 2,
      color: Colors.grey.shade300,
    );
  }
}
