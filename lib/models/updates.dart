import 'package:cloud_firestore/cloud_firestore.dart';

class Updates {
  Updates(this.id, this.update, this.createdAt,);

  final String id;
  final String update;
  final Timestamp createdAt;

  Updates.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        update = snapshot['update'],
        createdAt = snapshot['created_at'];
}