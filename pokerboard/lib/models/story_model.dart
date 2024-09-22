// lib/models/story_model.dart
class StoryModel {
  final String storyId;
  final String title;
  final String description;
  final String acceptanceCriteria;
  final List<String> attachments;
  final int priority;
  final Map<String, dynamic> votes; // {userId: vote}
  final bool votesRevealed;

  StoryModel({
    required this.storyId,
    required this.title,
    required this.description,
    required this.acceptanceCriteria,
    required this.attachments,
    required this.priority,
    required this.votes,
    required this.votesRevealed,
  });

  factory StoryModel.fromMap(Map<String, dynamic> data) {
    return StoryModel(
      storyId: data['storyId'],
      title: data['title'],
      description: data['description'],
      acceptanceCriteria: data['acceptanceCriteria'],
      attachments: List<String>.from(data['attachments']),
      priority: data['priority'],
      votes: data['votes'],
      votesRevealed: data['votesRevealed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storyId': storyId,
      'title': title,
      'description': description,
      'acceptanceCriteria': acceptanceCriteria,
      'attachments': attachments,
      'priority': priority,
      'votes': votes,
      'votesRevealed': votesRevealed,
    };
  }
}
