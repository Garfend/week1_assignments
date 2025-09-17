import 'package:flutter/material.dart';

abstract class OrderStatusUI {
  Widget build(BuildContext context, VoidCallback? onPressed);
}

class PendingStatusUI extends OrderStatusUI {
  @override
  Widget build(BuildContext context, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Mark as In Progress'),
    );
  }
}

class InProgressStatusUI extends OrderStatusUI {
  @override
  Widget build(BuildContext context, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Mark as Complete'),
    );
  }
}

class CompleteStatusUI extends OrderStatusUI {
  @override
  Widget build(BuildContext context, VoidCallback? onPressed) {
    return const SizedBox.shrink();
  }
}