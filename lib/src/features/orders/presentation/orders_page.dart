import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/models.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orders),
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(text: l10n.listingsTab),
            Tab(text: l10n.intentsTab),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => AppRouterDelegate.of(context).push('/listings/create'),
          ),
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          _ListingsTab(listings: state.listings, resolveItem: state.itemForListing),
          _IntentsTab(intents: state.intents),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppRouterDelegate.of(context).push('/orders/intent'),
        icon: const Icon(Icons.lightbulb_outline),
        label: Text(l10n.createIntent),
      ),
    );
  }
}

class _ListingsTab extends StatelessWidget {
  const _ListingsTab({required this.listings, required this.resolveItem});

  final List<SellListing> listings;
  final Item? Function(SellListing listing) resolveItem;

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return Center(child: Text(context.l10n.noResults));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: listings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final listing = listings[index];
        final item = resolveItem(listing);
        if (item == null) {
          return const SizedBox.shrink();
        }
        return Card(
          child: ListTile(
            title: Text(item.title),
            subtitle: Text('${listing.status} • ${Formatters.currency(listing.currentBid)}'),
            trailing: Text(Formatters.timeLeft(listing.endAt.difference(DateTime.now()))),
            onTap: () => AppRouterDelegate.of(context).push('/item/${item.id}'),
          ),
        );
      },
    );
  }
}

class _IntentsTab extends StatelessWidget {
  const _IntentsTab({required this.intents});

  final List<BuyIntent> intents;

  @override
  Widget build(BuildContext context) {
    if (intents.isEmpty) {
      return Center(child: Text(context.l10n.noResults));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: intents.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final intent = intents[index];
        return Card(
          child: ListTile(
            title: Text(intent.title),
            subtitle: Text('${intent.category} • ${Formatters.currency(intent.maxPrice)}'),
            trailing: Text(intent.status, style: theme.textTheme.labelLarge),
          ),
        );
      },
    );
  }
}
