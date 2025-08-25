# SwiftChat: A Real-Time Chat UI for Flutter

**SwiftChat** is a highly customizable and easy-to-use chat UI package
for Flutter. It provides a complete, responsive chat screen designed to
work with any real-time backend (like WebSockets), making it simple to
build modern chat applications with **text** and **media sharing**
support.

------------------------------------------------------------------------

## ✨ Features

-   💬 **Complete Chat UI** -- Pre-built chat screen with message
    bubbles and a message composer.\
-   🖼️ **Media Sharing** -- Optional "attach file" button for sending
    and displaying images.\
-   🔌 **Backend Agnostic** -- Works with any WebSocket backend using a
    stream-based architecture.\
-   🎨 **Highly Customizable** -- Change colors, text styles, and input
    decorations via `SwiftChatTheme`.\
-   🚀 **Lightweight & Performant** -- Optimized for performance with
    minimal footprint.

------------------------------------------------------------------------

## 🚀 Installation

Add `swift_chat` and dependencies to your `pubspec.yaml`:

``` yaml
dependencies:
  flutter:
    sdk: flutter
  swift_chat: ^1.2.0   # Use the latest version from pub.dev
  web_socket_channel: ^2.4.0
  image_picker: ^1.0.0
```

Install packages:

``` sh
flutter pub get
```

------------------------------------------------------------------------

## 📱 Example Usage

A complete example with **text and image sending**:

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

------------------------------------------------------------------------

## 🎨 Customization

You can fully customize the UI with `SwiftChatTheme`:

``` dart
SwiftChat(
  currentUser: _currentUser,
  messages: _messages,
  onSend: _handleSend,
  theme: const SwiftChatTheme(
    primaryBubbleColor: Colors.deepPurple,
    secondaryBubbleColor: Color(0xFFF0F0F0),
    sendButtonColor: Colors.deepPurple,
    primaryTextStyle: TextStyle(color: Colors.white, fontSize: 16),
  ),
)
```

------------------------------------------------------------------------

## 📎 Media Sharing (Optional)

The media sharing option is **completely optional**.\
The **attach file** button will **only appear** if you provide the
`onAttachFile` callback to the `SwiftChat` widget.

### ✅ To Enable Media Sharing:

``` dart
// The attach button will be visible
SwiftChat(
  // ... other properties
  onAttachFile: _handleAttachFile, 
)
```

### ✨ For a Text-Only Chat:

``` dart
// The attach button will be hidden
SwiftChat(
  // ... other properties
  // onAttachFile is not included
)
```

------------------------------------------------------------------------

## 🛠 SwiftChatTheme Properties

  ------------------------------------------------------------------------
  Property                           Type                Description
  ---------------------------------- ------------------- -----------------
  `backgroundColor`                  `Color`             Background color
                                                         of the chat
                                                         screen

  `primaryBubbleColor`               `Color`             Bubble color for
                                                         the current user

  `secondaryBubbleColor`             `Color`             Bubble color for
                                                         other users

  `primaryTextStyle`                 `TextStyle`         Text style for
                                                         current user
                                                         messages

  `secondaryTextStyle`               `TextStyle`         Text style for
                                                         other users
                                                         messages

  `composerBackgroundColor`          `Color`             Background color
                                                         of the message
                                                         composer

  `sendButtonColor`                  `Color`             Color of the send
                                                         button icon

  `inputDecoration`                  `InputDecoration`   Decoration for
                                                         the composer's
                                                         text field
  ------------------------------------------------------------------------

------------------------------------------------------------------------

## 🤝 Contributing

Contributions are welcome!\
If you find a bug or want a new feature, please open an issue or PR on
our GitHub repository.

------------------------------------------------------------------------

## 📜 License

This package is licensed under the **MIT License**.
