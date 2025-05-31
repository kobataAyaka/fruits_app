import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fruit_provider.dart';

class FruitDescriptionPage extends ConsumerStatefulWidget {
  final String fruitId;

  const FruitDescriptionPage({super.key, required this.fruitId});

  @override
  ConsumerState<FruitDescriptionPage> createState() =>
      _FruitDescriptionPageState();
}

class _FruitDescriptionPageState extends ConsumerState<FruitDescriptionPage> {
  late TextEditingController _nameController;
  bool _isEditing = false;
  bool _imageVisible = false;

  @override
  void initState() {
    super.initState();

    final initialFruit = ref
        .read(fruitListProvider)
        .firstWhere((fruit) => fruit['id'] == widget.fruitId);
    _nameController = TextEditingController(text: initialFruit['name']);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _imageVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleEditOrSave() {
    if (_isEditing) {
      final newFruitName = _nameController.text;
      if (newFruitName.isNotEmpty) {
        ref
            .read(fruitListProvider.notifier)
            .updateFruitName(widget.fruitId, _nameController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('과일 이름이 수정되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('과일 이름을 입력하세요.')),
        );
        return;
      }
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _toggleEdit() {
    if (_isEditing) {
      final newFruitName = _nameController.text;
      if (newFruitName.isNotEmpty) {
        ref
            .read(fruitListProvider.notifier)
            .updateFruitName(widget.fruitId, _nameController.text);
      }
    }
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fruit = ref.watch(fruitListProvider.select((fruits) {
      try {
        return fruits.firstWhere((fruit) => fruit['id'] == widget.fruitId);
      } catch (e) {
        return null;
      }
    }));

    if (fruit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('오류')),
        body: const Center(child: Text('과일을 찾을 수 없습니다.')),
      );
    }

    if (!_isEditing && _nameController.text != fruit['name']) {
      _nameController.text = fruit['name']!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(fruit['name']!),
      ),
      body: ListView(
        children: <Widget>[
          // 이미지 부분을 추가
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      blurRadius: 10.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: AnimatedOpacity(
                    opacity: _imageVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Image.asset(
                      'assets/images/${fruit['imageFileName']}',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 200),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '과일 이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '과일 이름을 입력하세요';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  // エンターキーで保存・編集モード切り替え
                  _toggleEditOrSave();
                },
              ),
            )
          else
            ListTile(
              title: const Text('이름'),
              subtitle: Text(fruit['name']!),
              leading: const Icon(Icons.label_outline),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: '이름 편집',
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              ),
            ),
          ListTile(
            title: const Text('열량'),
            subtitle: Text(fruit['calories']!),
          ),
          ListTile(
            title: const Text('학명'),
            subtitle: Text(fruit['scientificName']!),
          ),
        ],
      ),
    );
  }
}
