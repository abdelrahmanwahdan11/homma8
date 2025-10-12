import 'package:flutter/widgets.dart';

class RefreshHubController extends ChangeNotifier {
  final Map<String, ValueNotifier<int>> _slots = <String, ValueNotifier<int>>{};

  ValueListenable<int> listenable(String sectionId) {
    return _slots.putIfAbsent(sectionId, () => ValueNotifier<int>(0));
  }

  void broadcast(String sectionId) {
    final notifier = _slots.putIfAbsent(sectionId, () => ValueNotifier<int>(0));
    notifier.value = notifier.value + 1;
    notifyListeners();
  }
}

class RefreshHub extends InheritedNotifier<RefreshHubController> {
  const RefreshHub({
    super.key,
    required RefreshHubController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static RefreshHubController of(BuildContext context) {
    final hub = context.dependOnInheritedWidgetOfExactType<RefreshHub>();
    assert(hub != null, 'RefreshHub not found in context');
    return hub!.notifier!;
  }
}

class RefreshSlot extends StatelessWidget {
  const RefreshSlot({super.key, required this.sectionId, required this.builder});

  final String sectionId;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final controller = RefreshHub.of(context);
    final listenable = controller.listenable(sectionId);
    return ValueListenableBuilder<int>(
      valueListenable: listenable,
      builder: (context, _, __) {
        return builder(context);
      },
    );
  }
}
