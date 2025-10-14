import 'package:flutter/material.dart';

class AuctionCardSkeleton extends StatefulWidget {
  const AuctionCardSkeleton({super.key});

  @override
  State<AuctionCardSkeleton> createState() => _AuctionCardSkeletonState();
}

class _AuctionCardSkeletonState extends State<AuctionCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 0.8).animate(_controller),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class DetailsSkeleton extends StatelessWidget {
  const DetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 16),
        Container(height: 20, width: 200, color: Theme.of(context).colorScheme.surface),
        const SizedBox(height: 12),
        Container(height: 16, width: double.infinity, color: Theme.of(context).colorScheme.surface),
        const SizedBox(height: 16),
        Container(height: 16, width: double.infinity, color: Theme.of(context).colorScheme.surface),
      ],
    );
  }
}
