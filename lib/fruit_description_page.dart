import 'package:flutter/material.dart';

class FruitDescriptionPage extends StatefulWidget {
  final Map<String, String> fruit;

  const FruitDescriptionPage({super.key, required this.fruit});

  @override
  State<FruitDescriptionPage> createState() => _FruitDescriptionPageState();
}

class _FruitDescriptionPageState extends State<FruitDescriptionPage> {
  bool _imageVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _imageVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fruit['name']!),
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
                      'assets/images/${widget.fruit['imageFileName']}',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('이름'),
            subtitle: Text(widget.fruit['name']!),
          ),
          ListTile(
            title: const Text('열량'),
            subtitle: Text(widget.fruit['calories']!),
          ),
          ListTile(
            title: const Text('학명'),
            subtitle: Text(widget.fruit['scientificName']!),
          ),
        ],
      ),
    );
  }
}
