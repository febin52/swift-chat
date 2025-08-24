import 'chat_user.dart';

/// A class representing a single message in the chat.
class ChatMessage {
  final String id;
  final String text;
  final ChatUser user;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.user,
    required this.createdAt,
  });
}