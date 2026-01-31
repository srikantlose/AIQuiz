import 'dart:math';
import 'package:tflite_flutter/tflite_flutter.dart';

class AIRecommender {
  Interpreter? _interpreter;
  bool _loaded = false;
  final Random _random = Random();

  final List<String> topics = [
    "Basics of Climate Change",
    "Carbon Cycle & Greenhouse Gases",
    "Renewable Energy Basics",
    "Climate Policy & Agreements",
    "Advanced Climate Modeling",
  ];

  Future<void> loadModel() async {
    if (_loaded) return;
    _interpreter =
        await Interpreter.fromAsset('assets/models/recommendation_model.tflite');
    _loaded = true;
  }

  Future<String> recommendNextTopic(int score) async {
    if (!_loaded) await loadModel();

    final input = [
      [score / 100.0]
    ];
    final output =
        List.generate(1, (_) => List.filled(topics.length, 0.0));

    _interpreter!.run(input, output);

    final probs = output[0];

    // --- FIX: stochastic selection among top 2 ---
    final indexed = List.generate(
      probs.length,
      (i) => MapEntry(i, probs[i]),
    );

    indexed.sort((a, b) => b.value.compareTo(a.value));

    // pick best OR second-best (prevents same topic always)
    final chosen =
        indexed[_random.nextBool() ? 0 : min(1, indexed.length - 1)];

    return topics[chosen.key];
  }

  void close() {
    _interpreter?.close();
    _interpreter = null;
    _loaded = false;
  }
}
