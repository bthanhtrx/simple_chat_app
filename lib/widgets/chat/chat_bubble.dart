import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  String content;
  String? userName;
  String? userImage;
  bool isThisUser;

  ChatBubble(this.content, this.userName, this.userImage, this.isThisUser,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isThisUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 8,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Stack(clipBehavior: Clip.none, children: [
            Container(
              // width: 180,
              decoration: BoxDecoration(
                color: isThisUser ? Colors.grey : Colors.indigo,
                borderRadius: isThisUser
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment: isThisUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(userImage!.isNotEmpty) CircleAvatar(
                        backgroundImage: NetworkImage(userImage!),
                        radius: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '$userName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    content,
                    textAlign: TextAlign.end,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    maxLines: 10,
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .headlineMedium
                            ?.color),
                  ),
                ],
              ),
            ),
          ]),
        ),
        // ),
        const Flexible(flex: 1, child: SizedBox.shrink()),
      ],
    );
  }
}
