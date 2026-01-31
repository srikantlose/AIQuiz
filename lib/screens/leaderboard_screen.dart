import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LeaderboardScreen extends StatelessWidget {
  final DatabaseReference leaderboardRef =
      FirebaseDatabase.instance.ref("leaderboard");

   LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard")),
      body: StreamBuilder(
        stream: leaderboardRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          Map data = (snapshot.data!).snapshot.value as Map;
          List entries = data.entries.toList();
          entries.sort((a, b) => b.value.compareTo(a.value));

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${entries[index].key}"),
                trailing: Text("${entries[index].value} pts"),
              );
            },
          );
        },
      ),
    );
  }
}
