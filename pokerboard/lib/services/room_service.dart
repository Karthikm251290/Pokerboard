// lib/services/room_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room_model.dart';

class RoomService {
  final CollectionReference roomsCollection =
      FirebaseFirestore.instance.collection('rooms');

  // Create Room
  Future<String> createRoom(RoomModel room) async {
    DocumentReference docRef = await roomsCollection.add(room.toMap());
    return docRef.id;
  }

  // Get Room by ID
  Future<RoomModel> getRoomById(String roomId) async {
    DocumentSnapshot doc = await roomsCollection.doc(roomId).get();
    return RoomModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Stream Room
  Stream<RoomModel> streamRoom(String roomId) {
    return roomsCollection.doc(roomId).snapshots().map((snapshot) {
      return RoomModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Update Room
  Future<void> updateRoom(RoomModel room) async {
    await roomsCollection.doc(room.roomId).update(room.toMap());
  }
}
