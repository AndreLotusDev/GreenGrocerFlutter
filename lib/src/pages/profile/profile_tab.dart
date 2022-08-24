import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loja_virtual/src/pages/common_widgets/custom_text_field.dart';
import 'package:loja_virtual/src/config/app_data.dart' as APP_DATA;

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil do usuário"),

        actions: [
          IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.logout))
        ],
      ),

      body: ListView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),

        children: [

          CustomTextField(
            initialValue: APP_DATA.user.email,
            readOnly: true,

            iconData: Icons.email,
            label: "Email"
          ),

          CustomTextField(
            initialValue: APP_DATA.user.name,
            readOnly: true,

            iconData: Icons.person,
            label: "Nome"
          ),

          CustomTextField(
            initialValue: APP_DATA.user.phone,
            readOnly: true,

            iconData: Icons.phone,
            label: "Celular",
          ),

          CustomTextField(
            initialValue: APP_DATA.user.cpf,
            readOnly: true,

            iconData: Icons.file_copy,
            label: "CPF",
            isSecret: true,
          ),

          SizedBox(
            height: 50,
            child: OutlinedButton(

              style: OutlinedButton.styleFrom(

                side: const BorderSide(
                  color: Colors.green
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),

              onPressed: () {
                updatePassword();
              },
              child: const Text(
                "Atualizar senha"
              )
            ),
          )

        ],
      ),
    );
  }

  Future<bool?> updatePassword() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            
            child: Stack(
              children: [

                //CONTEUDO MAIN DO MODAL
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      //Cabecalho
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Atualização de senha",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      //Senha atual
                      const CustomTextField(
                        isSecret: true,
                        iconData: Icons.lock,
                        label: "Senha atual"
                      ),

                      //Nova senha
                      const CustomTextField(
                          isSecret: true,
                          iconData: Icons.lock_clock_outlined,
                          label: "Nova senha"
                      ),

                      //Confirmacao de senha
                      const CustomTextField(
                          isSecret: true,
                          iconData: Icons.lock_clock_outlined,
                          label: "Confirmar nova senha"
                      ),

                      //Botao de confirmacao
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),

                          onPressed: () {

                          },
                          child: const Text("Atualizar")
                        ),
                      )
                    ],
                  ),
                ),
                
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  )
                )
              ],
            ),
          );
        }
    );
  }

}

