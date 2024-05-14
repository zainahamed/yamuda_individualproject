import "package:flutter/material.dart";
import "package:yamudacarpooling/Colors/Colors.dart";

class MessageBubble extends StatelessWidget {
  final String content;
  final String time;
  final bool isMe;
  final String sender;

  const MessageBubble({
    Key? key,
    required this.content,
    required this.time,
    required this.isMe,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? bubbleColor1 : bubbleColor2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            !isMe
                ? Text(
                    sender.toString(),
                    style: const TextStyle(color: shadowColor),
                  )
                : const SizedBox(),
            Text(
              content,
              style: TextStyle(color: !isMe ? Secondary : Secondary),
            ),
            const SizedBox(height: 1),
            Text(
              time,
              style: TextStyle(
                color: !isMe ? Secondary : Primary,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
