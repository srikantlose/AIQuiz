import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String topic;

  QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.topic,
  });

  factory QuizModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return QuizModel(
      id: doc.id,
      question: (data['question'] as String?) ?? '',
      options: List<String>.from((data['options'] as List?) ?? const []),
      correctAnswerIndex: (data['correctAnswerIndex'] as num?)?.toInt() ?? 0,
      topic: (data['topic'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'topic': topic,
    };
  }
}
