import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> storeProject({
  required String userId,
  required String title,
  required String description,
  required List<String> objects,
}) async {
  print('🔥 storeProject CALLED');
  print('🔥 UID: $userId');
  print('🔥 TITLE: $title');

  await FirebaseFirestore.instance.collection('projects').add({
    'userId': userId,
    'title': title,
    'description': description,
    'objects': objects,
    'createdAt': Timestamp.now(), // ✅ FIXED
  });

  print('✅ PROJECT WRITTEN TO FIRESTORE');
}
