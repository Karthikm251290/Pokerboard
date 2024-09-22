// lib/services/story_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_model.dart';

class StoryService {
  final CollectionReference storiesCollection =
      FirebaseFirestore.instance.collection('stories');

  // Add Story
  Future<String> addStory(StoryModel story, String roomId) async {
    DocumentReference docRef = await storiesCollection.add({
      ...story.toMap(),
      'roomId': roomId,
    });
    return docRef.id;
  }

  // Get Stories by Room ID
  Stream<List<StoryModel>> getStoriesByRoomId(String roomId) {
    return storiesCollection
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => StoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Update Story
  Future<void> updateStory(StoryModel story) async {
    await storiesCollection.doc(story.storyId).update(story.toMap());
  }
}
