import 'package:flutter/material.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../common_widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {
      '#': RegExp(r'[0-9]')
    }
  );

  final phoneFormatter = MaskTextInputFormatter(
      mask: '## #####-####',
      filter: {
        '#': RegExp(r'[0-9]')
      }
  );

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [

              Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Cadastro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35
                        )),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 40
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(45)
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CustomTextField(
                            iconData: Icons.email,
                            label: 'Email'
                        ),
                        const CustomTextField(
                            iconData: Icons.password,
                            label: 'Senha',
                            isSecret: true,
                            suffixIcon: Icons.visibility
                        ),
                        const CustomTextField(
                            iconData: Icons.person,
                            label: 'Nome'
                        ),
                        CustomTextField(
                          iconData: Icons.phone,
                          label: 'Celular',
                          inputFormatters: [phoneFormatter],
                        ),
                        CustomTextField(
                          iconData: Icons.file_copy,
                          label: 'Cpf',
                          inputFormatters: [cpfFormatter],
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                              )
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Cadastrar',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),

              Positioned(
                top: 10,
                left: 10,
                child: SafeArea(
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
