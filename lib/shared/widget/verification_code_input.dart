import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationCodeInput extends StatefulWidget {
  final int length;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;

  const VerificationCodeInput({
    super.key,
    required this.length,
    required this.controller,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    widget.controller.addListener(_updateMainController);
  }

  void _updateMainController() {
    final code = _controllers.map((c) => c.text).join();
    widget.controller.text = code;
    if (widget.onChanged != null) widget.onChanged!(code);
    if (code.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!(code);
    }
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _updateMainController();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    widget.controller.removeListener(_updateMainController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.w,
      runSpacing: 8.h,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 40.w,
          height: 50.h,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
            ),
            onChanged: (value) => _onChanged(index, value),
            style: TextStyle(
              fontSize: 18.sp, // Légèrement réduit pour s'adapter
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      }),
    );
  }
}
