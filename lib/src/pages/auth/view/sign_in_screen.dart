import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:loja_virtual/src/pages/auth/controller/auth_controller.dart';
import 'package:loja_virtual/src/pages/auth/repository/auth_errors.dart';
import 'package:loja_virtual/src/pages/auth/view/forgot_password_dialog.dart';
import 'package:loja_virtual/src/pages/common_widgets/app_name.dart';
import 'package:loja_virtual/src/pages_routes/app_pages.dart';
import 'package:loja_virtual/src/services/utils_services.dart';
import 'package:loja_virtual/src/services/validators.dart';
import '../../common_widgets/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final utilServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Nome do APP
                  const AppName(
                    greenTitleColor: Colors.white,
                    textSize: 40,
                  ),

                  //Categorias
                  SizedBox(
                    height: 30,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        pause: Duration.zero,
                        animatedTexts: [
                          FadeAnimatedText('Frutas'),
                          FadeAnimatedText('Carnes'),
                          FadeAnimatedText('Legumes'),
                          FadeAnimatedText('Cereais'),
                        ],
                      ),
                    ),
                  )
                ],
              )),

              //Formulario
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        iconData: Icons.email,
                        label: 'Email',
                        validator: emailValidator,
                        customTextFieldController: emailController,
                      ),

                      CustomTextField(
                        iconData: Icons.password,
                        label: 'Senha',
                        isSecret: true,
                        suffixIcon: Icons.visibility,
                        validator: passwordValidator,
                        customTextFieldController: passwordController,
                      ),

                      //Entrar
                      SizedBox(
                        height: 50,
                        child: GetX<AuthController>(
                          builder: (controller) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18))),
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();

                                        var isValid =
                                            _formKey.currentState!.validate();

                                        if (isValid) {
                                          String email = emailController.text;
                                          String password =
                                              passwordController.text;

                                          await controller.signIn(
                                              email: email, password: password);
                                        }
                                      },
                                child: controller.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.grey,
                                      )
                                    : const Text(
                                        'Entrar',
                                        style: TextStyle(fontSize: 18),
                                      ));
                          },
                        ),
                      ),

                      //Esqueceu a senha
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              bool? result = await showDialog(
                                context: context,
                                builder: (_) {
                                  return ForgotPasswordDialog(
                                    email: emailController.text,
                                  );
                                },
                              );

                              if (result ?? false) {
                                utilServices.showToast(
                                  message:
                                      'Um link de recuperação foi enviado para o seu email',
                                );
                              }
                            },
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                  color: CustomColors.customContrastColor),
                            ),
                          ),
                        ),
                      ),

                      //Divisoria
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey.withAlpha(90),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text('Ou'),
                              )),
                          Expanded(
                            flex: 2,
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey.withAlpha(90),
                            ),
                          ),
                        ],
                      ),

                      //Criar conta
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                side: BorderSide(
                                    width: 2,
                                    color: Colors.green.withAlpha(90))),
                            onPressed: () {
                              Get.toNamed(PagesRoutes.signUpRoute);
                            },
                            child: const Text('Criar Conta',
                                style: TextStyle(fontSize: 18)),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
