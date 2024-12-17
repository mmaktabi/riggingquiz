import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';
import 'package:rigging_quiz/widgets/icon.dart';

class QTextField extends StatefulWidget {
  final String labelText;
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
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final void Function(String)? onSubmitted;

  const QTextField({
    super.key,
    required this.labelText,
    this.hintText,
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
    this.suffixText = '',
    this.keyboardType,
    this.autofillHints,
    this.onSubmitted,
  });

  @override
  State<QTextField> createState() => _QTextFieldState();
}

class _QTextFieldState extends State<QTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool _isFieldFocused = false;
  bool _obscureText = false;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    // Fokus-Node und Controller initialisieren
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.isPassword;

    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(() => setState(() {
      _charCount = _controller.text.length;
    }));
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFieldFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        obscureText: _obscureText,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        cursorColor: QColors.primaryColor,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.maxChars),
        ],
        autofillHints: widget.autofillHints,
        style: primaryTextStyle(color: QColors.primaryColor),
        decoration: _inputDecoration(),
        validator: widget.validator,
        onSaved: widget.onSaved,
        onFieldSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      label: _label(),
      fillColor: widget.formFieldColor,
      filled: true,
      prefixIcon:
      widget.icon != null ? Icon(widget.icon, size: 23) : null,
      suffixIcon: widget.isPassword
          ? IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: QColors.primaryColor,
        ),
        onPressed: () => setState(() {
          _obscureText = !_obscureText;
        }),
      )
          : null,
      suffixText: widget.showCharCount
          ? "$_charCount/${widget.maxChars}"
          : widget.suffixText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: widget.focusedBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: widget.borderColor),
      ),
    );
  }

  Widget _label() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
      decoration: BoxDecoration(
        color: _isFieldFocused ? QColors.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: QText(
        text: widget.labelText,
        fontSize: 14,
        color: _isFieldFocused ? QColors.white : QColors.primaryColor,
      ),
    );
  }
}
