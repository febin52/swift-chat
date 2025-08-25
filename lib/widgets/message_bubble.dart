import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../swift_chat.dart';

/// A widget that displays a single chat message in a bubble.
///
/// It can render either text or image content based on the message's `MediaType`.
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  final SwiftChatTheme theme;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final alignment =
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor =
        isCurrentUser ? theme.primaryBubbleColor : theme.secondaryBubbleColor;
    final borderRadius = isCurrentUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          )
        : const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        // Display sender's name for other users' messages
        if (!isCurrentUser)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
            child: Text(
              message.user.name,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        // The message bubble container
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
          ),
          // Constrain the width of the bubble
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: _buildMessageContent(),
          ),
        ),
        // Display the timestamp below the bubble
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            '${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  /// Builds the content of the message bubble based on its type.
  Widget _buildMessageContent() {
    switch (message.mediaType) {
      case MediaType.image:
        return _buildImageMessage();
      case MediaType.text:
        return _buildTextMessage();
    }
  }

  /// Builds a text message widget.
  Widget _buildTextMessage() {
    final textStyle =
        isCurrentUser ? theme.primaryTextStyle : theme.secondaryTextStyle;
    return Text(message.text ?? '', style: textStyle);
  }

  /// Builds an image message widget with loading and error states.
  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        message.mediaUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      ),
    );
  }
}
