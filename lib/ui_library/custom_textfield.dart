import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quikapp/ui_library/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.maxLength,
    required this.hintText,
    this.action = TextInputAction.next,
    this.controller,
    this.labelText,
    this.initialValue = '',
    this.keyboard,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.shadow = true,
    this.onChanged,
    this.validator,
    this.suffix,
    this.isFilled,
    this.fillColor,
    this.contentPadding,
    this.onSubmitted,
    this.enable = true,
    this.prefixIcon,
    this.textCapitalization = TextCapitalization.none, // Provide a default value here
    this.onSaved, // New parameter for onSaved callback
    this.focusNode, // New parameter for FocusNode


    Key? key,
  }) : super(key: key);

  final bool obscureText;
  final bool shadow;
  final int maxLines;
  final String initialValue;
  final int? maxLength;
  final String hintText;
  final String? labelText;
  final Function(String)? onSaved; // Callback for onSaved
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final TextInputAction action;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  final Widget? suffix;
  final bool? isFilled;
  final Color? fillColor;
  final bool enable;
  final bool readOnly;
  final Widget? prefixIcon;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode; // New FocusNode parameter

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Material(
        // elevation: 2,
        // shadowColor: shadow ? AppTheme.lightgrey : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                focusNode: focusNode, // Use FocusNode
                onSaved: (value) {
                  if (onSaved != null) {
                    onSaved!(value ?? '');
                  }
                },
                style: AppTheme.h6.copyWith(color: AppTheme.borderColor),
                controller: controller,
                readOnly: readOnly,
                maxLines: maxLines,
                inputFormatters: maxLength != null
                    ? [LengthLimitingTextInputFormatter(maxLength)]
                    : null,
                decoration: InputDecoration(
                  prefixIcon: prefixIcon,
                  prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 18),
                  labelText: labelText,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: AppTheme.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: contentPadding ??
                      const EdgeInsets.fromLTRB(10, 1.0, 5.0, 1.0),
                  labelStyle: const TextStyle(
                    color: AppTheme.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppTheme.borderColor,
                      width: 1,
                    ),
                    gapPadding: 4,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppTheme.borderColor,
                      width: 2,
                    ),
                    gapPadding: 4,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: suffix,
                  ),
                  errorStyle: const TextStyle(
                      height: 0,
                      color: AppTheme.white
                    // Hide the error text
                  ),
                  filled: isFilled,
                  fillColor: fillColor,
                ),
                initialValue:
                controller == null ? initialValue : null,
                keyboardType: keyboard,
                obscureText: obscureText,
                onChanged: onChanged,
                validator: (value) {
                  if (onChanged != null) {
                    onChanged!(value ?? '');
                  }
                  return validator?.call(value);
                },
                textInputAction: action,
                onFieldSubmitted: onSubmitted,
                enabled: enable,

                textCapitalization:textCapitalization,
                autocorrect: false,
                enableSuggestions: false,


              ),
            ],
          ),
        ),
      ),
    );
  }
}