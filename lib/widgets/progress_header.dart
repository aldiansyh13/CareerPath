import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double progress; // 0..1
  const ProgressHeader(
      {super.key, required this.title, this.subtitle, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700)),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black54)),
        ],
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
              value: progress.clamp(0, 1), minHeight: 8),
        ),
      ],
    );
  }
}
