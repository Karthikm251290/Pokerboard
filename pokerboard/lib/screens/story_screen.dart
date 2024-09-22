// lib/screens/story_screen.dart
import 'package:flutter/material.dart';
import '../services/story_service.dart';
import '../models/story_model.dart';

class StoryScreen extends StatefulWidget {
  static const routeName = '/story';
  final String roomId;

  const StoryScreen({super.key, required this.roomId});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final StoryService _storyService = StoryService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _acceptanceCriteriaController =
      TextEditingController();

  void _addStory() async {
    StoryModel newStory = StoryModel(
      storyId: '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      acceptanceCriteria: _acceptanceCriteriaController.text.trim(),
      attachments: [],
      priority: 0,
      votes: {},
      votesRevealed: false,
    );

    await _storyService.addStory(newStory, widget.roomId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title TextField
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            // Description TextField
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            // Acceptance Criteria TextField
            TextField(
              controller: _acceptanceCriteriaController,
              decoration:
                  const InputDecoration(labelText: 'Acceptance Criteria'),
            ),
            // Add Story Button
            ElevatedButton(
              onPressed: _addStory,
              child: const Text('Add Story'),
            ),
          ],
        ),
      ),
    );
  }
}
