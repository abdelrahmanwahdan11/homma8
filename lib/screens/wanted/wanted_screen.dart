import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../data/models.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/glass_container.dart';

class WantedScreen extends StatefulWidget {
  const WantedScreen({super.key});

  @override
  State<WantedScreen> createState() => _WantedScreenState();
}

class _WantedScreenState extends State<WantedScreen> {
  final ValueNotifier<int> _tabNotifier = ValueNotifier(0);
  late final List<WantedRequest> _mockRequests;
  ValueNotifier<List<WantedRequest>>? _savedRequests;

  @override
  void initState() {
    super.initState();
    _mockRequests = List.generate(6, (index) {
      return WantedRequest(
        id: 'mock_$index',
        title: 'Concept Request ${index + 1}',
        targetPrice: 200 + (index * 50),
        description: 'Looking for a concept design mock ${index + 1}.',
        city: 'City ${index + 1}',
        expiresAt: DateTime.now().add(Duration(days: 10 + index)),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _savedRequests ??= AppState.of(context).wantedNotifier;
  }

  @override
  void dispose() {
    _tabNotifier.dispose();
    super.dispose();
  }

  void _onNavigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(AppRoutes.offers);
        break;
      case 2:
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
        break;
    }
  }

  void _openAddDialog() {
    final lang = LanguageManager.of(context);
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final cityController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? expiresAt;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: GlassContainer(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t('add_request'),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: lang.t('title')),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? lang.t('invalid_form')
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: lang.t('target_price')),
                    validator: (value) {
                      final parsed = double.tryParse(value ?? '');
                      if (parsed == null || parsed <= 0) {
                        return lang.t('invalid_form');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(labelText: lang.t('city')),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration:
                        InputDecoration(labelText: lang.t('description')),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        expiresAt = picked;
                      }
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(lang.t('expires_at')),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final request = WantedRequest(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            title: titleController.text.trim(),
                            targetPrice:
                                double.parse(priceController.text.trim()),
                            description: descriptionController.text.trim(),
                            city: cityController.text.trim(),
                            expiresAt: expiresAt,
                          );
                          AppState.of(context).addWantedRequest(request);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(lang.t('save')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      titleController.dispose();
      priceController.dispose();
      cityController.dispose();
      descriptionController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('wanted_title')),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 2,
        onTap: _onNavigate,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _tabNotifier,
              builder: (context, index, _) {
                return SegmentedButton<int>(
                  segments: [
                    ButtonSegment(
                      value: 0,
                      label: Text(lang.t('all_requests')),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text(lang.t('my_requests')),
                    ),
                  ],
                  selected: {index},
                  onSelectionChanged: (value) =>
                      _tabNotifier.value = value.first,
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: _tabNotifier,
                builder: (context, index, _) {
                  if (index == 0) {
                    return _RequestsList(requests: _mockRequests);
                  }
                  final saved = _savedRequests;
                  if (saved == null) {
                    return const SizedBox.shrink();
                  }
                  return ValueListenableBuilder<List<WantedRequest>>(
                    valueListenable: saved,
                    builder: (context, items, __) {
                      return _RequestsList(requests: items);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestsList extends StatelessWidget {
  const _RequestsList({required this.requests});

  final List<WantedRequest> requests;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = LanguageManager.of(context);
    if (requests.isEmpty) {
      return Center(
        child: Text(
          lang.t('no_offers'),
          style: theme.textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = requests[index];
        return GlassContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.title,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                '${lang.t('target_price')}: ${request.targetPrice.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium,
              ),
              if (request.city.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  request.city,
                  style: theme.textTheme.bodySmall,
                ),
              ],
              if (request.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  request.description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              if (request.expiresAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${lang.t('expires_at')}: ${request.formattedExpiry}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
