// lib/screens/vote_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_model.dart';
import '../services/story_service.dart';
import '../services/auth_service.dart';
import '../widgets/estimation_card.dart';
import '../models/user_model.dart';

class VoteScreen extends StatefulWidget {
  final StoryModel story;
  final String roomId;
  final bool isObserver;

  const VoteScreen({
    super.key,
    required this.story,
    required this.roomId,
    required this.isObserver,
  });

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  final StoryService _storyService = StoryService();
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  String? _selectedVote;
  bool _hasVoted = false;
  late Stream<StoryModel> _storyStream;

  // Estimation values (Fibonacci scale)
  List<String> estimationValues = [
    '1',
    '2',
    '3',
    '5',
    '8',
    '13',
    '21',
    '34',
    '?'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _listenToStory();
  }

  void _getCurrentUser() async {
    String currentUserId = _authService.currentUserId;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    setState(() {
      _currentUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    });
  }

  void _listenToStory() {
    _storyStream = _storyService.streamStory(widget.story.storyId);
  }

  void _submitVote() async {
    String currentUserId = _authService.currentUserId;

    Map<String, dynamic> updatedVotes = Map.from(widget.story.votes);
    updatedVotes[currentUserId] = _selectedVote;

    // Check if all users have voted
    bool allUsersVoted = await _checkAllUsersVoted(updatedVotes);

    // Update story votes
    await _storyService.updateStoryVotes(
      storyId: widget.story.storyId,
      votes: updatedVotes,
      votesRevealed: allUsersVoted,
    );

    setState(() {
      _hasVoted = true;
    });
  }

  Future<bool> _checkAllUsersVoted(Map<String, dynamic> votes) async {
    // Get the room participants
    DocumentSnapshot roomDoc = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .get();

    List<String> participantIds = List<String>.from(roomDoc['participantIds']);

    // Exclude observers from participants
    List<String> voters = [];
    for (String userId in participantIds) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc['role'] == 'user') {
        voters.add(userId);
      }
    }

    // Check if all users have voted
    return votes.keys.toSet().containsAll(voters);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StoryModel>(
      stream: _storyStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          StoryModel story = snapshot.data!;

          // Check if current user has voted
          String currentUserId = _authService.currentUserId;
          _hasVoted = story.votes.containsKey(currentUserId);

          bool allVotesSubmitted = story.votesRevealed;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Vote on Story'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Story Details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    story.title,
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    story.description,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Estimation Cards
                if (!widget.isObserver && !_hasVoted)
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: estimationValues.length,
                      itemBuilder: (context, index) {
                        String value = estimationValues[index];
                        return EstimationCard(
                          value: value,
                          isSelected: _selectedVote == value,
                          onTap: () {
                            setState(() {
                              _selectedVote = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                // Submit Vote Button
                if (!widget.isObserver && !_hasVoted)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _selectedVote != null ? _submitVote : null,
                      child: const Text('Submit Vote'),
                    ),
                  ),
                // Waiting Message
                if (!widget.isObserver && _hasVoted && !allVotesSubmitted)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Waiting for other users to vote...',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                // Display Votes if Revealed or if Observer
                if ((widget.isObserver || allVotesSubmitted))
                  Expanded(
                    child: ListView.builder(
                      itemCount: story.votes.length,
                      itemBuilder: (context, index) {
                        String userId = story.votes.keys.elementAt(index);
                        String vote = story.votes[userId];

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData) {
                              String userName =
                                  userSnapshot.data!['name'] ?? 'User';
                              return ListTile(
                                title: Text(userName),
                                trailing: Text(
                                  vote,
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            } else {
                              return const ListTile(
                                title: Text('Loading...'),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Vote on Story'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
