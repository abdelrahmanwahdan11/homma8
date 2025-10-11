import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة'),
        bottom: TabBar(
          controller: _controller,
          tabs: const <Widget>[
            Tab(text: 'بيع بالمزاد'),
            Tab(text: 'نشر طلب شراء'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const <Widget>[
          _AuctionForm(),
          _RequestForm(),
        ],
      ),
    );
  }
}

class _AuctionForm extends StatefulWidget {
  const _AuctionForm();

  @override
  State<_AuctionForm> createState() => _AuctionFormState();
}

class _AuctionFormState extends State<_AuctionForm> {
  final TextEditingController _image = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _startPrice = TextEditingController(text: '100');

  @override
  void dispose() {
    _image.dispose();
    _title.dispose();
    _description.dispose();
    _startPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        TextField(
          controller: _image,
          decoration: const InputDecoration(labelText: 'رابط صورة (اختياري)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _title,
          decoration: const InputDecoration(labelText: 'العنوان'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _description,
          decoration: const InputDecoration(labelText: 'الوصف'),
          maxLines: 4,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _startPrice,
          decoration: const InputDecoration(labelText: 'سعر البداية'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('حُفظ كمسودة (محاكاة)')),
            );
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}

class _RequestForm extends StatefulWidget {
  const _RequestForm();

  @override
  State<_RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<_RequestForm> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _specs = TextEditingController();
  final TextEditingController _maxPrice = TextEditingController(text: '100');
  final TextEditingController _location = TextEditingController(text: 'الرياض');

  @override
  void dispose() {
    _title.dispose();
    _specs.dispose();
    _maxPrice.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        TextField(
          controller: _title,
          decoration: const InputDecoration(labelText: 'العنوان'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _specs,
          decoration: const InputDecoration(labelText: 'المواصفات'),
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _maxPrice,
          decoration: const InputDecoration(labelText: 'السعر الأقصى'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _location,
          decoration: const InputDecoration(labelText: 'الموقع'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم نشر الطلب (محاكاة)')),
            );
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
