import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    required this.index,
    required this.onIndexChanged,
    required this.body,
    this.actions = const <Widget>[],
  });

  final List<NavigationDestination> destinations;
  final int index;
  final ValueChanged<int> onIndexChanged;
  final Widget body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 840;
    if (isWide) {
      return Scaffold(
        appBar: AppBar(actions: actions),
        body: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: onIndexChanged,
              extended: width >= 1100,
              labelType: NavigationRailLabelType.selected,
              destinations: destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      icon: destination.icon,
                      selectedIcon: destination.selectedIcon ?? destination.icon,
                      label: destination.label,
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        destinations: destinations,
        onDestinationSelected: onIndexChanged,
      ),
    );
  }
}
