// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/room_service.dart';
import '../models/room_model.dart';
import 'room_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RoomService _roomService = RoomService();
  final AuthService _authService = AuthService();

  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _joinRoomIdController = TextEditingController();

  void _createRoom() async {
    String currentUserId = _authService._auth.currentUser!.uid;
    RoomModel newRoom = RoomModel(
      roomId: '',
      roomName: _roomNameController.text.trim(),
      ownerId: currentUserId,
      participantIds: [],
      isLocked: false,
    );
    String roomId = await _roomService.createRoom(newRoom);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomScreen(
          roomId: roomId,
          isObserver: true,
        ),
      ),
    );
  }

  void _joinRoom() {
    String roomId = _joinRoomIdController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomScreen(
          roomId: roomId,
          isObserver: false,
        ),
      ),
    );
  }

  void _signOut() async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning Poker - Home'),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Create Room
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(labelText: 'Room Name'),
            ),
            ElevatedButton(
              onPressed: _createRoom,
              child: const Text('Create Room'),
            ),
            const Divider(),
            // Join Room
            TextField(
              controller: _joinRoomIdController,
              decoration: const InputDecoration(labelText: 'Room ID'),
            ),
            ElevatedButton(
              onPressed: _joinRoom,
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}
