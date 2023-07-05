import 'package:cloud_firestore/cloud_firestore.dart';

class Updates {
  Updates(this.update, this.createdAt);

  final String update;
  final Timestamp createdAt;

  Updates.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : update = snapshot['update'],
        createdAt = snapshot['created_at'];
}