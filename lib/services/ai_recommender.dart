// lib/services/ai_recommender.dart
import 'package:tflite_flutter/tflite_flutter.dart';

class AIRecommender {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  // topics must match the order used during training
  final List<String> topics = [
    "Basics of Climate Change",
    "Carbon Cycle & Greenhouse Gases",
    "Renewable Energy Basics",
    "Climate Policy & Agreements",
    "Advanced Climate Modeling",
  ];

  // call this at app startup (or in initState) and await it
  Future<void> loadModel() async {
    if (_isLoaded) return;
    // asset path should match pubspec entry
    _interpreter = await Interpreter.fromAsset('models/recommendation_model.tflite');

    _isLoaded = true;
  }

  // score is 0..100
  Future<String> recommendNextTopic(int score) async {
    if (!_isLoaded) {
      await loadModel();
    }
    final normalized = score / 100.0;

    // input: shape [1,1] for our model
    var input = List.filled(1, List.filled(1, normalized)); // [[0.85]]
    // output: shape [1, num_classes]
    var output = List.generate(1, (_) => List.filled(topics.length, 0.0));

    _interpreter!.run(input, output);

    final probs = output[0];
    // find argmax
    double maxv = probs[0];
    int maxi = 0;
    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > maxv) {
        maxv = probs[i];
        maxi = i;
      }
    }

    return topics[maxi];
  }

  void close() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }
}
