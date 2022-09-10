import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final IconData iconData;
  final String label;
  final bool isSecret;
  final IconData? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? customTextFieldController;
  final TextInputType? textInputType;
  final GlobalKey<FormFieldState>? formFieldKey;

  const CustomTextField(
      {Key? key,
      required this.iconData,
      required this.label,
      this.isSecret = false,
      this.suffixIcon,
      this.inputFormatters,
      this.initialValue,
      this.readOnly = false,
      this.validator,
      this.customTextFieldController,
      this.textInputType,
      this.onSaved,
      this.formFieldKey})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;

  @override
  void initState() {
    if (widget.isSecret) {
      isObscure = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          key: widget.formFieldKey,
          keyboardType: widget.textInputType,
          controller: widget.customTextFieldController,
          initialValue: widget.initialValue,
          readOnly: widget.readOnly,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          obscureText: isObscure,
          onSaved: widget.onSaved,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.iconData),
            suffixIcon: widget.isSecret
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                        isObscure ? widget.suffixIcon : Icons.visibility_off))
                : null,
            labelText: widget.label,
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ));
  }
}
