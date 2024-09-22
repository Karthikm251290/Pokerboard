// lib/screens/room_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/room_service.dart';
import '../services/story_service.dart';
import '../models/room_model.dart';
import '../models/story_model.dart';
import 'story_screen.dart';
import 'vote_screen.dart';
import '../services/auth_service.dart';
import '../widgets/story_card.dart';
import '../models/user_model.dart';
import 'dart:async';

class RoomScreen extends StatefulWidget {
  final String roomId;
  final bool isObserver;

  const RoomScreen({
    super.key,
    required this.roomId,
    required this.isObserver,
  });

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final RoomService _roomService = RoomService();
  final StoryService _storyService = StoryService();
  final AuthService _authService = AuthService();

  RoomModel? _room;
  List<StoryModel> _stories = [];
  StreamSubscription? _roomSubscription;
  StreamSubscription? _storiesSubscription;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _listenToRoom();
    _listenToStories();
    _addUserToRoom();
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    _storiesSubscription?.cancel();
    super.dispose();
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

  void _addUserToRoom() async {
    String currentUserId = _authService.currentUserId;
    if (!widget.isObserver) {
      await _roomService.addParticipant(widget.roomId, currentUserId);
    }
  }

  void _listenToRoom() {
    _roomSubscription = _roomService.streamRoom(widget.roomId).listen((room) {
      setState(() {
        _room = room;
      });
    });
  }

  void _listenToStories() {
    _storiesSubscription =
        _storyService.getStoriesByRoomId(widget.roomId).listen((stories) {
      setState(() {
        _stories = stories;
      });
    });
  }

  void _addStory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryScreen(roomId: widget.roomId),
      ),
    );
  }

  void _navigateToVote(StoryModel story) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoteScreen(
          story: story,
          roomId: widget.roomId,
          isObserver: widget.isObserver,
        ),
      ),
    );
  }

  void _leaveRoom() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_room == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Room'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Room: ${_room!.roomName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _leaveRoom,
          ),
        ],
      ),
      body: Column(
        children: [
          // Participants List (Optional)
          if (widget.isObserver)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Participants:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.isObserver)
            SizedBox(
              height: 80.0,
              child: StreamBuilder<RoomModel>(
                stream: _roomService.streamRoom(widget.roomId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    RoomModel room = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: room.participantIds.length,
                      itemBuilder: (context, index) {
                        String userId = room.participantIds[index];
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData) {
                              String userName =
                                  userSnapshot.data!['name'] ?? 'User';
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Chip(
                                  label: Text(userName),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          const Divider(),
          Expanded(
            child: _stories.isEmpty
                ? const Center(
                    child: Text('No stories available.'),
                  )
                : ListView.builder(
                    itemCount: _stories.length,
                    itemBuilder: (context, index) {
                      StoryModel story = _stories[index];
                      return StoryCard(
                        story: story,
                        onTap: () => _navigateToVote(story),
                      );
                    },
                  ),
          ),
          if (widget.isObserver)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _addStory,
                child: const Text('Add Story'),
              ),
            ),
        ],
      ),
    );
  }
}
