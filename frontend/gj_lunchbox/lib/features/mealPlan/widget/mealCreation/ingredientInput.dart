import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IngredientInputField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final int index;

  const IngredientInputField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.index,
  });

  @override
  State<IngredientInputField> createState() => _IngredientInputFieldState();
}

class _IngredientInputFieldState extends State<IngredientInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);

    // Listen for changes and update parent
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(covariant IngredientInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _controller, // Attach the controller
        onChanged: widget.onChanged, // Capture user input
        decoration: InputDecoration(
          hintText: "Ingredient ${widget.index + 1}",
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
