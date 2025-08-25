import 'chat_user.dart';

/// The type of content in a chat message.
enum MediaType {
  /// A standard text message.
  text,

  /// An image message, requiring a `mediaUrl`.
  image,
}

/// Represents a single message in a chat session.
///
/// Each message has a unique ID, the user who sent it, a timestamp,
/// and content which can be text, media, or both.
class ChatMessage {
  /// The unique identifier for the message.
  final String id;

  /// The text content of the message. Can be null if it's a media-only message.
  final String? text;

  /// The user who sent the message.
  final ChatUser user;

  /// The time the message was created.
  final DateTime createdAt;

  /// An optional URL for media content (e.g., an image).
  final String? mediaUrl;

  /// The type of media this message contains. Defaults to `text`.
  final MediaType mediaType;

  /// Creates a new instance of a [ChatMessage].
  ///
  /// A message must contain either [text] or a [mediaUrl].
  ChatMessage({
    required this.id,
    required this.user,
    required this.createdAt,
    this.text,
    this.mediaUrl,
    this.mediaType = MediaType.text,
  }) : assert(
          text != null || mediaUrl != null,
          'A message must have either text or a mediaUrl.',
        );
}
