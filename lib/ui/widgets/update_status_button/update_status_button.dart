import 'package:flutter/material.dart';
import 'available_status.dart';

class UpdateStatusButton extends StatelessWidget {
  final OrderStatusUI statusUI;
  final VoidCallback? onPressed;

  const UpdateStatusButton({
    super.key,
    required this.statusUI,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return statusUI.build(context, onPressed);
  }
}