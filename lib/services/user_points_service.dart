import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addPointsToUser({
  required String userId,
  required int points,
}) async {
  final userRef =
  FirebaseFirestore.instance.collection('users').doc(userId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(userRef);

    if (!snapshot.exists) {
      transaction.set(userRef, {
        'points': points,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      final currentPoints = snapshot['points'] ?? 0;
      transaction.update(userRef, {
        'points': currentPoints + points,
      });
    }
  });
}
