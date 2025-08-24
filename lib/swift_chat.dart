library swift_chat;

import 'package:flutter/material.dart';
import 'models/chat_message.dart';
import 'models/chat_user.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_composer.dart';

// Export models so they can be used by the package consumer.
export 'models/chat_message.dart';
export 'models/chat_user.dart';

/// A comprehensive and customizable chat UI widget, designed for real-time
/// communication like WebSockets.
class SwiftChat extends StatefulWidget {
  final ChatUser currentUser;
  final List<ChatMessage> messages;
  final void Function(String) onSend;
  final SwiftChatTheme theme;

  const SwiftChat({
    super.key,
    required this.currentUser,
    required this.messages,
    required this.onSend,
    this.theme = const SwiftChatTheme(),
  });

  @override
  State<SwiftChat> createState() => _SwiftChatState();
}

class _SwiftChatState extends State<SwiftChat> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(covariant SwiftChat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToBottom();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8.0),
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final message = widget.messages[index];
              final isCurrentUser = message.user.id == widget.currentUser.id;
              return MessageBubble(
                message: message,
                isCurrentUser: isCurrentUser,
                theme: widget.theme,
              );
            },
          ),
        ),
        MessageComposer(
          onSend: widget.onSend,
          theme: widget.theme,
        ),
      ],
    );
  }
}

/// A class to hold theme data for the `SwiftChat` widget.
class SwiftChatTheme {
  final Color backgroundColor;
  final Color primaryBubbleColor;
  final Color secondaryBubbleColor;
  final TextStyle primaryTextStyle;
  final TextStyle secondaryTextStyle;
  final Color composerBackgroundColor;
  final Color sendButtonColor;
  final InputDecoration inputDecoration;

  const SwiftChatTheme({
    this.backgroundColor = Colors.white,
    this.primaryBubbleColor = Colors.blue,
    this.secondaryBubbleColor = const Color(0xFFE0E0E0),
    this.primaryTextStyle = const TextStyle(color: Colors.white),
    this.secondaryTextStyle = const TextStyle(color: Colors.black),
    this.composerBackgroundColor = Colors.white,
    this.sendButtonColor = Colors.blue,
    this.inputDecoration = const InputDecoration(
      hintText: 'Send a message...',
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
    ),
  });
}
