import 'dart:async';

import 'package:flutter/material.dart';

import '../core/localization/app_localizations.dart';

typedef SearchCallback = void Function(String query);

class BazaarSearchBar extends StatefulWidget {
  const BazaarSearchBar({super.key, required this.onQueryChanged});

  final SearchCallback onQueryChanged;

  @override
  State<BazaarSearchBar> createState() => _BazaarSearchBarState();
}

class _BazaarSearchBarState extends State<BazaarSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: l10n['search'],
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: (value) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          widget.onQueryChanged(value.trim());
        });
      },
      onSubmitted: (value) => widget.onQueryChanged(value.trim()),
      textInputAction: TextInputAction.search,
    );
  }
}
