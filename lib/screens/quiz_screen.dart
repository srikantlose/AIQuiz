import 'package:flutter/material.dart';
import '../services/ai_recommender.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int score = 0;
  int questionIndex = 0;
  bool quizFinished = false;
  String? recommendedTopic;

  late List<Map<String, Object>> questions;

  @override
  void initState() {
    super.initState();
    questions = getQuestionsForTopic("Basics of Climate Change");
  }

  List<Map<String, Object>> getQuestionsForTopic(String topic) {
    if (topic == "Renewable Energy Basics") {
      return [
        q("Which energy is renewable?", "Solar"),
        q("Hydropower uses?", "Water"),
        q("Wind energy depends on?", "Air movement"),
        q("Which is clean energy?", "Solar"),
        q("Renewables reduce?", "Pollution"),
      ];
    }

    if (topic == "Climate Policy & Agreements") {
      return [
        q("Paris Agreement focuses on?", "Climate change"),
        q("Kyoto Protocol targets?", "Emissions"),
        q("Climate policy is made by?", "Governments"),
        q("Carbon tax reduces?", "Emissions"),
        q("UN climate body?", "UNFCCC"),
      ];
    }

    return [
      q("Main cause of global warming?", "Burning fossil fuels"),
      q("Greenhouse gas?", "Carbon dioxide"),
      q("Ozone layer protects from?", "UV rays"),
      q("Climate change affects?", "Global patterns"),
      q("Deforestation increases?", "CO₂"),
    ];
  }

  Map<String, Object> q(String question, String correct) {
    final options = [
      correct,
      "Wind",
      "Water",
      "Soil",
    ]..shuffle();

    return {
      "question": question,
      "answers": options
          .map((o) => {"text": o, "isCorrect": o == correct})
          .toList(),
    };
  }

  void answerQuestion(bool isCorrect) {
    if (isCorrect) score += 10;

    if (questionIndex < questions.length - 1) {
      setState(() => questionIndex++);
    } else {
      submitQuiz();
    }
  }

  Future<void> submitQuiz() async {
    final recommender = AIRecommender();
    await recommender.loadModel();

    final topic = await recommender.recommendNextTopic(score);

    setState(() {
      recommendedTopic = topic;
      quizFinished = true;
    });
  }

  void retakeQuiz() {
    setState(() {
      score = 0;
      questionIndex = 0;
      quizFinished = false;
    });
  }

  void startRecommendedQuiz() {
    if (recommendedTopic == null) return;

    setState(() {
      score = 0;
      questionIndex = 0;
      quizFinished = false;
      questions = getQuestionsForTopic(recommendedTopic!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quizFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text("Result")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Score: $score / 50",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Recommended Topic:",
                  style: const TextStyle(fontSize: 18)),
              Text(recommendedTopic ?? "",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: retakeQuiz,
                    child: const Text("Retake"),
                  ),
                  ElevatedButton(
                    onPressed: startRecommendedQuiz,
                    child: const Text("GO"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = questions[questionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Adaptive Climate Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (questionIndex + 1) / questions.length,
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion["question"] as String,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...(currentQuestion["answers"]
                    as List<Map<String, Object>>)
                .map(
              (ans) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () =>
                      answerQuestion(ans["isCorrect"] as bool),
                  child: Text(ans["text"] as String),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
