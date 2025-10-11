import 'package:flutter/material.dart';

import '../errors.dart';

class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    required this.state,
    required this.builder,
    this.onRetry,
    super.key,
  });

  final AsyncState<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error) => _ErrorView(error: error, onRetry: onRetry),
      data: (data) => builder(context, data),
    );
  }
}

class AsyncState<T> {
  const AsyncState._({this.data, this.error, required this.isLoading});

  const AsyncState.loading() : this._(isLoading: true);
  const AsyncState.error(AppError error)
      : this._(isLoading: false, error: error);
  const AsyncState.data(T data) : this._(isLoading: false, data: data);

  final bool isLoading;
  final T? data;
  final AppError? error;

  R when<R>({
    required R Function() loading,
    required R Function(AppError error) error,
    required R Function(T data) data,
  }) {
    if (isLoading) return loading();
    if (this.error != null) return error(this.error!);
    return data(this.data as T);
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, this.onRetry});

  final AppError error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
          const SizedBox(height: 12),
          Text(error.message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ]
        ],
      ),
    );
  }
}
