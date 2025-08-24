
/// A class representing a user in the chat.
class ChatUser {
  final String id;
  final String name;
  final String? avatarUrl;

  ChatUser({
    required this.id,
    required this.name,
    this.avatarUrl,
  });
}
