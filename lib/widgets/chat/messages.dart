import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/widgets/chat/chat_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = snapshot.data?.docs;
        print('chat len: ${chatDocs?.length}');
        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => ChatBubble(
            chatDocs?[index]['text'],
            chatDocs?[index]['userName'],
            chatDocs?[index]['userImage'],
            chatDocs?[index]['userId'] ==
                FirebaseAuth.instance.currentUser?.uid,
            key: ValueKey(chatDocs?[index].id),
          ),
          itemCount: chatDocs?.length,
        );
      },
    );
  }
}
