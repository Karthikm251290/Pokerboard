// lib/widgets/story_card.dart
import 'package:flutter/material.dart';
import '../models/story_model.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onTap;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Shorten the description for the preview
    String descriptionPreview = story.description.length > 50
        ? '${story.description.substring(0, 50)}...'
        : story.description;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 2.0,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(
              story.priority.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            story.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(descriptionPreview),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
