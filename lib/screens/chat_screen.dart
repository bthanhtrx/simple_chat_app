import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/widgets/chat/messages.dart';
import 'package:simple_chat_app/widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    final firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.requestPermission();
    firebaseMessaging.subscribeToTopic('chat');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        actions: [
          DropdownButton(
            icon: const Icon(Icons.more_vert),
            items: const [
              DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout')
                    ],
                  ))
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: Messages()),
          NewMessage(),
        ],
      ),

      /*StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/HVpr30t23wKuklaUPGiX/messages')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(8),
              child: Text('${snapshot.data?.docs[index]['info']}'),
            ),
          );
        },
      ),*/
      // floatingActionButton: FloatingActionButton(
      //     child: const Icon(Icons.add),
      //     onPressed: () {
      //       FirebaseFirestore.instance
      //           // .collection('chats/HVpr30t23wKuklaUPGiX/messages')
      //           .collection('chat')
      //           .add({'text': 'hello'});
      //     }),
    );
  }
}
