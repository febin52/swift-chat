import 'package:flutter/material.dart';
import '../swift_chat.dart';

/// A widget that displays a single chat message in a bubble.
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
    final textStyle =
        isCurrentUser ? theme.primaryTextStyle : theme.secondaryTextStyle;
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
        if (!isCurrentUser)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
            child: Text(
              message.user.name,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
          ),
          child: Text(message.text, style: textStyle),
        ),
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
}
