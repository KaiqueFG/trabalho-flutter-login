import 'package:flutter/material.dart';

/// Botão principal que mostra um indicador de progresso e
/// bloqueia novos toques enquanto [loading] for `true`.
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading ? null : onPressed,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: loading
            ? SizedBox.square(
                key: const ValueKey('loading'),
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : Text(label, key: const ValueKey('label')),
      ),
    );
  }
}
