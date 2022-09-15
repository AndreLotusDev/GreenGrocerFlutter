import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:loja_virtual/src/pages/auth/controller/auth_controller.dart';
import 'package:loja_virtual/src/services/validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../common_widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});

  final phoneFormatter = MaskTextInputFormatter(
      mask: '## #####-####', filter: {'#': RegExp(r'[0-9]')});

  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

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
                      child: Text('Cadastro',
                          style: TextStyle(color: Colors.white, fontSize: 35)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 40),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(45))),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            iconData: Icons.email,
                            label: 'Email',
                            textInputType: TextInputType.emailAddress,
                            validator: emailValidator,
                            onSaved: (value) {
                              authController.user.email = value;
                            },
                          ),
                          CustomTextField(
                              iconData: Icons.password,
                              label: 'Senha',
                              isSecret: true,
                              suffixIcon: Icons.visibility,
                              validator: passwordValidator,
                              onSaved: (value) {
                                authController.user.password = value;
                              }),
                          CustomTextField(
                              iconData: Icons.person,
                              label: 'Nome',
                              validator: nameValidator,
                              onSaved: (value) {
                                authController.user.name = value;
                              }),
                          CustomTextField(
                              iconData: Icons.phone,
                              label: 'Celular',
                              inputFormatters: [phoneFormatter],
                              textInputType: TextInputType.phone,
                              validator: phoneValidator,
                              onSaved: (value) {
                                authController.user.phone = value;
                              }),
                          CustomTextField(
                              iconData: Icons.file_copy,
                              label: 'Cpf',
                              inputFormatters: [cpfFormatter],
                              textInputType: TextInputType.number,
                              validator: cpfValidator,
                              onSaved: (value) {
                                authController.user.cpf = value;
                              }),
                          SizedBox(
                            height: 50,
                            child: Obx(() {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18))),
                                onPressed: authController.isLoading.value
                                    ? null
                                    : () {
                                        Focus.of(context).unfocus();

                                        var isValid =
                                            _formKey.currentState!.validate();

                                        if (isValid) {
                                          _formKey.currentState!.save();

                                          authController.signUp();
                                        }

                                        return;
                                      },
                                child: authController.isLoading.value
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        'Cadastrar',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                              );
                            }),
                          )
                        ],
                      ),
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
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
