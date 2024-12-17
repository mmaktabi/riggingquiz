import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/icon.dart';

class QTextField extends StatefulWidget {
  final String labelText;
  final String? initialValue;
  final String? hintText;
  final String? suffixText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final bool readOnly;
  final bool isPassword;
  final TextEditingController? controller;
  final IconData? icon;
  final Color formFieldColor;
  final Color focusedBorderColor;
  final Color borderColor;
  final int maxLines;
  final int minLines;
  final int maxChars;
  final bool showCharCount;
  final double padding;
  final FocusNode? focusNode;
  final bool numberField;
  final bool rationalNumber;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final void Function(String)? onSubmitted;

  const QTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.readOnly = false,
    this.isPassword = false,
    this.controller,
    this.icon,
    this.formFieldColor = QColors.formBgColor,
    this.focusedBorderColor = QColors.primaryColor,
    this.borderColor = QColors.secondaryColor,
    this.focusNode,
    this.maxLines = 1,
    this.minLines = 1,
    this.padding = 8,
    this.maxChars = 300,
    this.showCharCount = false,
    this.numberField = false,
    this.rationalNumber = false,
    this.suffixText = '',
    this.keyboardType,
    this.autofillHints,
    this.onSubmitted, // Neuer Parameter für Enter
  });

  @override
  State<QTextField> createState() => _QTextFieldState();
}

class _QTextFieldState extends State<QTextField> {
  FocusNode? _internalFocusNode;
  TextEditingController? _internalController;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  TextEditingController get _controller =>
      widget.controller ?? _internalController!;
  bool _isFieldFocused = false;
  bool _obscureText = false;
  final List<TextInputFormatter> _inputFormatters = [];
  final TextInputType _keyboardType = TextInputType.text;

  @override
  void initState() {
    super.initState();
    // Erstelle interne Instanzen nur, wenn sie nicht extern bereitgestellt wurden
    _internalController = widget.controller ?? TextEditingController();

    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }
    _obscureText = widget.isPassword;
    _focusNode.addListener(_handleFocusChange);
    // Aktualisiere den Zustand, wenn der Controller aktualisiert wird
    if (_controller.text.isNotEmpty) {
      _updateIsFieldFocused(true);
    }
    _setupInputFormatters();
  }
  void _handleFocusChange() {
    if (mounted) {
      if (_focusNode.hasFocus != _isFieldFocused) {
        _updateIsFieldFocused(_focusNode.hasFocus);
      }
    }
  }


  void _updateIsFieldFocused(bool isFocused) {
    setState(() {
      _isFieldFocused = isFocused;
    });
  }

  void _handleHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _setupInputFormatters() {
    _inputFormatters.clear(); // Bestehende Formatters bereinigen
    _inputFormatters.add(
      LengthLimitingTextInputFormatter(widget.maxChars),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    if (widget.controller != null) {
      _internalController?.dispose();
    }
    super.dispose();
  }

  bool _isTextTooLong = false;
  int _charCount = 0;

  void countChars(String value) {
    setState(() {
      _charCount = value.length;
      _isTextTooLong = _charCount > widget.maxChars;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: TextFormField(
        autofillHints: widget.autofillHints,
        focusNode: widget.focusNode ?? _focusNode,
        controller: widget.controller ?? _controller,
        readOnly: widget.readOnly,
        inputFormatters: _inputFormatters,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType ?? _keyboardType,
        cursorColor: QColors.primaryColor,
        cursorWidth: 1,
        style: primaryTextStyle(color: QColors.primaryColor),
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        decoration: _inputDecoration(_isFieldFocused),
        validator: widget.validator,
        onSaved: widget.onSaved,
        onFieldSubmitted: (value) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(
                value); // Callback aufrufen, wenn Enter gedrückt wird
          }
        },
        onChanged: (value) {
          if (widget.maxChars != 100) {
            countChars(value);
          }
          if (widget.onChanged != null) {
            widget.onChanged?.call(value);
          }
        },
      ),
    );
  }

  InputDecoration _inputDecoration(bool isFieldFocusedNotEmpty) {
    return InputDecoration(
//contentPadding: EdgeInsets.symmetric(vertical:  15, horizontal: 16),
      //  isCollapsed: true,
      hintText: widget.hintText,
      label: _label(isFieldFocusedNotEmpty),
      fillColor: widget.formFieldColor,
      prefixIcon: widget.icon != null ? Icon(widget.icon, size: 23) : null,
      suffixIcon: widget.isPassword ? _togglePasswordVisibility() : null,
      errorStyle: primaryTextStyle(color: ColorsHelpers.red, fontSize: 11),
      hintStyle: primaryTextStyle(),
      suffixText: widget.showCharCount
          ? _isTextTooLong
          ? "$_charCount/${widget.maxChars}"
          : "$_charCount/${widget.maxChars}"
          : widget.suffixText,
      suffixStyle: primaryTextStyle(fontSize: 13, color: QColors.primaryColor),
      filled: true,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22))),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: widget.focusedBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: widget.borderColor),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorsHelpers.red),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorsHelpers.red),
      ),
    );
  }

  Widget _label(bool isFieldFocused) {
    return Container(
      decoration: BoxDecoration(
        color: isFieldFocused ? QColors.primaryColor : QColors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
        child: QText(
          text: widget.labelText,
          fontSize: 14,
          color: isFieldFocused ? QColors.white : QColors.primaryColor,
        ),
      ),
    );
  }

  Widget _togglePasswordVisibility() {
    return CustomIcon(
      icon: _obscureText ? Icons.visibility_off : Icons.visibility,
      size: 23,
      color: QColors.primaryColor,
      onTap: () {
        _handleHidePassword();
      },
    );
  }
}