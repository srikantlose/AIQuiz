import 'package:flutter/material.dart';
import '../services/ai_recommender.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int score = 0;
  int questionIndex = 0;

  final List<Map<String, Object>> questions = [
    {
      "question": "1. What is the main cause of global warming?",
      "answers": [
        {"text": "Deforestation", "isCorrect": false},
        {"text": "Burning fossil fuels", "isCorrect": true},
        {"text": "Volcanic eruptions", "isCorrect": false},
        {"text": "Earth’s orbit", "isCorrect": false},
      ]
    },
    {
      "question": "2. Which gas is the biggest contributor to the greenhouse effect?",
      "answers": [
        {"text": "Oxygen", "isCorrect": false},
        {"text": "Carbon dioxide", "isCorrect": true},
        {"text": "Nitrogen", "isCorrect": false},
        {"text": "Hydrogen", "isCorrect": false},
      ]
    },
    {
      "question": "3. Which renewable energy source is most used worldwide?",
      "answers": [
        {"text": "Solar", "isCorrect": false},
        {"text": "Wind", "isCorrect": false},
        {"text": "Hydropower", "isCorrect": true},
        {"text": "Geothermal", "isCorrect": false},
      ]
    },
    {
      "question": "4. What does 'climate change' mainly refer to?",
      "answers": [
        {"text": "Seasonal weather changes", "isCorrect": false},
        {"text": "Long-term shifts in global weather patterns", "isCorrect": true},
        {"text": "Daily temperature variation", "isCorrect": false},
        {"text": "Local rainfall", "isCorrect": false},
      ]
    },
    {
      "question": "5. Which layer of the atmosphere contains the ozone layer?",
      "answers": [
        {"text": "Troposphere", "isCorrect": false},
        {"text": "Stratosphere", "isCorrect": true},
        {"text": "Mesosphere", "isCorrect": false},
        {"text": "Exosphere", "isCorrect": false},
      ]
    },
    {
      "question": "6. Which international agreement aims to reduce global warming?",
      "answers": [
        {"text": "Kyoto Protocol", "isCorrect": false},
        {"text": "Paris Agreement", "isCorrect": true},
        {"text": "Montreal Protocol", "isCorrect": false},
        {"text": "Doha Amendment", "isCorrect": false},
      ]
    },
    {
      "question": "7. Which human activity absorbs CO₂ from the atmosphere?",
      "answers": [
        {"text": "Burning coal", "isCorrect": false},
        {"text": "Deforestation", "isCorrect": false},
        {"text": "Planting trees", "isCorrect": true},
        {"text": "Industrial farming", "isCorrect": false},
      ]
    },
    {
      "question": "8. Which is NOT a greenhouse gas?",
      "answers": [
        {"text": "Methane", "isCorrect": false},
        {"text": "Water vapor", "isCorrect": false},
        {"text": "Ozone", "isCorrect": false},
        {"text": "Argon", "isCorrect": true},
      ]
    },
    {
      "question": "9. Which region is warming about twice as fast as the global average?",
      "answers": [
        {"text": "Africa", "isCorrect": false},
        {"text": "Antarctica", "isCorrect": false},
        {"text": "Asia", "isCorrect": false},
        {"text": "Arctic region", "isCorrect": true},
      ]
    },
    {
      "question": "10. What percentage of the Earth’s water is fresh water?",
      "answers": [
        {"text": "2.5%", "isCorrect": true},
        {"text": "10%", "isCorrect": false},
        {"text": "25%", "isCorrect": false},
        {"text": "50%", "isCorrect": false},
      ]
    },
  ];

  void nextQuestion(bool isCorrect) {
    if (isCorrect) {
      setState(() => score += 10);
    }
    setState(() {
      questionIndex++;
    });
  }

  Future<void> submitQuiz() async {
    final recommender = AIRecommender();
    await recommender.loadModel(); // ensure model loaded
    String nextTopic = await recommender.recommendNextTopic(score);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text("Next Step")),
          body: Center(
            child: Text(
              "Your next recommended topic: $nextTopic",
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );

    // optionally close interpreter if you won’t use it again
    recommender.close();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion =
        questionIndex < questions.length ? questions[questionIndex] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🌍 Climate Quiz"),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        elevation: 4,
      ),
      body: currentQuestion != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (questionIndex + 1) / questions.length,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        currentQuestion["question"] as String,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...(currentQuestion["answers"] as List<Map<String, Object>>)
                      .map(
                    (ans) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 4, 147, 230),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size(double.infinity, 50),
                          elevation: 3,
                        ),
                        onPressed: () =>
                            nextQuestion(ans["isCorrect"] as bool),
                        child: Text(ans["text"] as String,
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 248, 236),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.check_circle),
                onPressed: submitQuiz,
                label: const Text(
                  "Submit Quiz",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }
}
