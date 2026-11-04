import 'package:flutter/material.dart';

import '../../../../core/utils/password_strength.dart';

/// Indicador visual de força da senha (3 segmentos + rótulo).
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final strength = PasswordStrength.of(password);
    final color = switch (strength) {
      PasswordStrength.empty => scheme.outlineVariant,
      PasswordStrength.weak => scheme.error,
      PasswordStrength.medium => const Color(0xFFF59E0B),
      PasswordStrength.strong => const Color(0xFF16A34A),
    };

    return Semantics(
      label: 'Força da senha: ${strength.label}',
      child: Row(
        children: [
          for (var i = 1; i <= 3; i++) ...[
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 6,
                decoration: BoxDecoration(
                  color: i <= strength.level ? color : scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          SizedBox(
            width: 104,
            child: Text(
              strength.label,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: strength == PasswordStrength.empty
                        ? scheme.onSurfaceVariant
                        : color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
