import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_learning_tracker/models/quiz_model.dart';



class QuizService {
  final CollectionReference<Map<String, dynamic>> quizCollection =
      FirebaseFirestore.instance.collection('quizzes');

  Future<List<QuizModel>> getQuizzes(String topic) async {
    final snapshot = await quizCollection.where('topic', isEqualTo: topic).get();
    return snapshot.docs.map((doc) => QuizModel.fromFirestore(doc)).toList();
  }
}
