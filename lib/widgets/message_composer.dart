import 'package:flutter/material.dart';
import '../swift_chat.dart';

/// A widget for composing and sending messages.
class MessageComposer extends StatefulWidget {
  final Function(String) onSend;
  final SwiftChatTheme theme;
  /// An optional callback to trigger when the attach file button is pressed.
  /// If null, the button will not be displayed.
  final VoidCallback? onAttachFile;

  const MessageComposer({
    super.key,
    required this.onSend,
    required this.theme,
    this.onAttachFile,
  });

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _canSend = _controller.text.trim().isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_canSend) {
      widget.onSend(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: widget.theme.composerBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Show the attach file button if the callback is provided
            if (widget.onAttachFile != null)
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: widget.onAttachFile,
                color: widget.theme.sendButtonColor,
              ),
            // The text input field
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: widget.theme.inputDecoration,
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            // The send button
            IconButton(
              icon: const Icon(Icons.send),
              color: _canSend ? widget.theme.sendButtonColor : Colors.grey,
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
