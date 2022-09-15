import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/src/models/order_model.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

class PaymentDialog extends StatelessWidget {
  PaymentDialog({Key? key, required this.order}) : super(key: key);

  final OrderModel order;
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            //CONTEUDO
            _PixCode(
              order: order,
            ),

            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            )
          ],
        ));
  }
}

class _PixCode extends StatelessWidget {
  _PixCode({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;
  final UtilsServices utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Pagamento com PIX',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          //QR CODE
          Image.memory(
            utilsServices.decodeQrCodeImage(order.qrCodeImage),
            height: 200,
            width: 200,
          ),

          //VENCIMENTO
          Text(
            'Vencimento: ${utilsServices.formatDateTime(order.overdueDt)}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),

          //TOTAL
          Text(
            'Total: ${utilsServices.priceToCurrency(order.total)}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          //COPIA COLA
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: const BorderSide(
                width: 2,
                color: Colors.green,
              ),
            ),
            onPressed: () {
              FlutterClipboard.copy(order.copyAndPaste);
              utilsServices.showToast(message: 'Código copiado!');
            },
            icon: const Icon(Icons.copy),
            label: const Text(
              'Copiar código pix',
              style: TextStyle(fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}
