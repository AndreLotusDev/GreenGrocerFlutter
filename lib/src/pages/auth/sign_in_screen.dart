import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:loja_virtual/src/pages/auth/sign_up_screen.dart';
import 'package:loja_virtual/src/pages/common_widgets/app_name.dart';
import '../base/base_screen.dart';
import '../common_widgets/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CustomTextField(
                        iconData: Icons.email, label: 'Email'),

                    const CustomTextField(
                      iconData: Icons.password,
                      label: 'Senha',
                      isSecret: true,
                      suffixIcon: Icons.visibility,
                    ),

                    //Entrar
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (c) {
                              return BaseScreen();
                            }));
                          },
                          child: const Text(
                            'Entrar',
                            style: TextStyle(fontSize: 18),
                          )),
                    ),

                    //Esqueceu a senha
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                  color: CustomColors.customContrastColor),
                            )),
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
                              child: Text('Ou'),
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
                        padding: EdgeInsets.all(10),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              side: BorderSide(
                                  width: 2, color: Colors.green.withAlpha(90))),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (c) {
                                return SignUpScreen();
                              }),
                            );
                          },
                          child: const Text('Criar Conta',
                              style: const TextStyle(fontSize: 18)),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
