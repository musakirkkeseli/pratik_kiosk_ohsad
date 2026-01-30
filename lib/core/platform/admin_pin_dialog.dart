import 'package:flutter/material.dart';

Future<bool?> showAdminPinDialog({
  required BuildContext context,
  required String correctPin,
}) {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscure = true;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Admin Girişi'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'PIN',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => obscure = !obscure),
                    icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: (v) {
                  if ((v ?? '').isEmpty) return 'PIN gerekli';
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('İptal'),
              ),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  final ok = controller.text.trim() == correctPin;
                  Navigator.of(ctx).pop(ok);
                },
                child: const Text('Giriş'),
              ),
            ],
          );
        },
      );
    },
  );
}
