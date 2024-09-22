// lib/models/room_model.dart
class RoomModel {
  final String roomId;
  final String roomName;
  final String ownerId; // Observer ID
  final List<String> participantIds;
  final bool isLocked;

  RoomModel({
    required this.roomId,
    required this.roomName,
    required this.ownerId,
    required this.participantIds,
    required this.isLocked,
  });

  factory RoomModel.fromMap(Map<String, dynamic> data) {
    return RoomModel(
      roomId: data['roomId'],
      roomName: data['roomName'],
      ownerId: data['ownerId'],
      participantIds: List<String>.from(data['participantIds']),
      isLocked: data['isLocked'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'ownerId': ownerId,
      'participantIds': participantIds,
      'isLocked': isLocked,
    };
  }
}
