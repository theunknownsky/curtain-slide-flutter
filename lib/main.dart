import 'package:flutter/material.dart';
import 'registerPage.dart';

void main() {
  runApp(const CurtainSlideApp());
}

class CurtainSlideApp extends StatelessWidget {
  const CurtainSlideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BufferPage(title: 'CurtainSlide'),
    );
  }
}

class BufferPage extends StatefulWidget {
  const BufferPage({super.key, required this.title});

  final String title;

  @override
  State<BufferPage> createState() => _BufferPageState();
}

class _BufferPageState extends State<BufferPage> {
  @override
  Widget build(BuildContext context) {
    return RegisterPage(title: widget.title);
  }
}

