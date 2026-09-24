import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const VibeApp());
}

class VibeApp extends StatelessWidget {
  const VibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Georgia'),
      home: const VibePage(),
    );
  }
}

class Vibe {
  final String name;
  final List<Color> colors;
  final IconData icon;

  const Vibe(this.name, this.colors, this.icon);
}

class VibePage extends StatefulWidget {
  const VibePage({super.key});

  @override
  State<VibePage> createState() => _VibePageState();
}

class _VibePageState extends State<VibePage>
    with SingleTickerProviderStateMixin {
  final List<Vibe> _vibes = const [
    Vibe('Golden Hour', [Color(0xFFFFA751), Color(0xFFFFE259)], Icons.wb_sunny_outlined),
    Vibe('Deep Ocean', [Color(0xFF0F2027), Color(0xFF2C5364)], Icons.water),
    Vibe('Cotton Candy', [Color(0xFFFFAFBD), Color(0xFFC2E9FB)], Icons.icecream_outlined),
    Vibe('Midnight Forest', [Color(0xFF134E5E), Color(0xFF71B280)], Icons.forest_outlined),
    Vibe('Lavender Dream', [Color(0xFF834D9B), Color(0xFFD04ED6)], Icons.nightlight_outlined),
    Vibe('Citrus Burst', [Color(0xFFF9D423), Color(0xFFFF4E50)], Icons.local_florist_outlined),
    Vibe('Cyber Punk', [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)], Icons.bolt_outlined),
    Vibe('Rose Quartz', [Color(0xFFF6D5F7), Color(0xFFFBE9D7)], Icons.favorite_outline),
  ];

  late Vibe _current;
  final Random _rand = Random();

  @override
  void initState() {
    super.initState();
    _current = _vibes[_rand.nextInt(_vibes.length)];
  }

  void _generateVibe() {
    setState(() {
      Vibe next;
      do {
        next = _vibes[_rand.nextInt(_vibes.length)];
      } while (next.name == _current.name && _vibes.length > 1);
      _current = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _current.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Icon(
                          _current.icon,
                          key: ValueKey(_current.name),
                          size: 96,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _current.name,
                          key: ValueKey('${_current.name}_text'),
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "today's vibe",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: ElevatedButton.icon(
                  onPressed: _generateVibe,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('New Vibe'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}