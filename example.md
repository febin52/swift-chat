``` dart
import 'package:flutter/material.dart';
import 'package:swift_chat/swift_chat.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SwiftChat Example',
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _currentUser = ChatUser(
    id: 'user_${Random().nextInt(9999)}',
    name: 'You',
  );
  final List<ChatMessage> _messages = [];
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080'), // Your WebSocket server address
  );

  @override
  void initState() {
    super.initState();
    _channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      final user = ChatUser(id: decoded['userId'], name: decoded['userName']);
      final mediaType =
          decoded['mediaType'] == 'image' ? MediaType.image : MediaType.text;

      final message = ChatMessage(
        id: decoded['id'],
        user: user,
        createdAt: DateTime.parse(decoded['createdAt']),
        text: decoded['text'],
        mediaUrl: decoded['mediaUrl'],
        mediaType: mediaType,
      );

      if (mounted) {
        setState(() {
          _messages.add(message);
        });
      }
    });
  }

  void _handleSend(String text) {
    final message = ChatMessage(
      id: 'msg_${Random().nextInt(9999)}',
      text: text,
      user: _currentUser,
      createdAt: DateTime.now(),
      mediaType: MediaType.text,
    );
    _sendMessage(message);
  }

  Future<void> _handleAttachFile() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      const imageUrl = 'https://placehold.co/600x400.png';
      final message = ChatMessage(
        id: 'msg_${Random().nextInt(9999)}',
        user: _currentUser,
        createdAt: DateTime.now(),
        mediaUrl: imageUrl,
        mediaType: MediaType.image,
      );
      _sendMessage(message);
    }
  }

  void _sendMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });

    final messageData = {
      'id': message.id,
      'text': message.text,
      'userId': message.user.id,
      'userName': message.user.name,
      'createdAt': message.createdAt.toIso8601String(),
      'mediaUrl': message.mediaUrl,
      'mediaType': message.mediaType.name,
    };
    _channel.sink.add(jsonEncode(messageData));
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SwiftChat Example')),
      body: SwiftChat(
        currentUser: _currentUser,
        messages: _messages,
        onSend: _handleSend,
        onAttachFile: _handleAttachFile,
      ),
    );
  }
}
```