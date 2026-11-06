import 'package:flutter/material.dart';

import 'dart:math';

import '../audio_service.dart'; // استدعي ملف الخدمة اللي عملناه

class VibeBoardScreen extends StatefulWidget {
  const VibeBoardScreen({super.key});

  @override
  State<VibeBoardScreen> createState() => _VibeBoardScreenState();
}

class _VibeBoardScreenState extends State<VibeBoardScreen> {
  final AudioService _audioService = AudioService();

  final List<String> _quotes = [
    "“Every small step you take today brings you closer to your big dreams tomorrow! ✨”",
    "“Be proud of yourself; the journey of hard work is filled with joy and success. 🌸”",
  ];

  late String _currentQuote;

  @override
  void initState() {
    super.initState();
    _currentQuote = _quotes[0];
  }

  void _changeQuote() {
    final random = Random();
    setState(() {
      _currentQuote = _quotes[random.nextInt(_quotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positive Vibe Board 🎧✨'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade200,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.purple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // قسم الاقتباسات
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      _currentQuote,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.pink.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _changeQuote,
                      child: const Text('Another Quote'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Ambient Sound 🌧️☕',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // كروت الأصوات
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildSoundCard(
                    'Rain 🌧️',
                    'https://actions.google.com/sounds/v1/weather/rain_heavy_loud.ogg',
                  ),
                  _buildSoundCard(
                    'Coffee ☕',
                    'https://actions.google.com/sounds/v1/ambiences/coffee_shop.ogg',
                  ),
                  _buildSoundCard(
                    'Waves 🌊',
                    'https://actions.google.com/sounds/v1/water/stream_flowing.ogg',
                  ),
                ],
              ),
            ),

            // زرار لإيقاف الصوت الحالي لو حابة
            if (_audioService.hasActiveSound)
              ElevatedButton.icon(
                onPressed: () async {
                  await _audioService.stopSound();
                  setState(() {});
                },
                icon: const Icon(Icons.stop),
                label: Text(
                  'Stop Playing (${_audioService.currentPlayingTitle})',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade200,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundCard(String title, String url) {
    bool isPlaying = _audioService.isPlaying(title);

    return InkWell(
      onTap: () async {
        await _audioService.playSound(title, url);
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: isPlaying ? Colors.pink.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isPlaying
              ? Border.all(color: Colors.pink.shade700, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 40,
              color: isPlaying ? Colors.white : Colors.black54,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPlaying ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
