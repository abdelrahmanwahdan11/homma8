import 'package:flutter/material.dart';

class AiInfoSheet extends StatelessWidget {
  const AiInfoSheet({super.key, required this.summary, required this.approxPrice});

  final String summary;
  final double approxPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Insights', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(summary),
          const SizedBox(height: 12),
          Text('Approx price: ${approxPrice.toStringAsFixed(0)} USD'),
          const SizedBox(height: 12),
          const Text('Pros: Industrial minimal build, lime-accented detailing.'),
          const SizedBox(height: 4),
          const Text('Cons: Mock data, confirm condition.'),
        ],
      ),
    );
  }
}
