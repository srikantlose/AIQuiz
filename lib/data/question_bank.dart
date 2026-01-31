import '../models/question.dart';

// BASIC
final climateBasicsQuestions = [
  Question(
    question: "What is climate change?",
    options: ["Weather change", "Long-term temperature change", "Rainfall", "Wind"],
    correctIndex: 1,
  ),
  Question(
    question: "Main cause of climate change?",
    options: ["Volcanoes", "Solar flares", "Human activities", "Oceans"],
    correctIndex: 2,
  ),
];

// RENEWABLE
final renewableEnergyQuestions = [
  Question(
    question: "Which is renewable energy?",
    options: ["Coal", "Oil", "Solar", "Gas"],
    correctIndex: 2,
  ),
  Question(
    question: "Wind energy comes from?",
    options: ["Sun", "Air movement", "Water", "Earth"],
    correctIndex: 1,
  ),
];

// ADVANCED
final advancedClimateQuestions = [
  Question(
    question: "Climate models are based on?",
    options: ["Physics", "Guessing", "History", "Maps"],
    correctIndex: 0,
  ),
];

final defaultQuestions = climateBasicsQuestions;
