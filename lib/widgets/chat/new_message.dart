import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _chatInputController = TextEditingController();
  String enterMessage = '';

  @override
  void dispose() {
    _chatInputController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userName = await FirebaseFirestore.instance
        .collection('users')
        .doc('$uid')
        .get()
        .then((value) => value.data()?['username']);
    final userImage = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => value.data()?['profile_url']);

    FirebaseFirestore.instance.collection('chat').add({
      'text': enterMessage,
      'createdTime': Timestamp.now(),
      'userId': uid,
      'userName': userName,
      'userImage': userImage,
    });

    Apis.sendPushNotification(userName, enterMessage);

    _chatInputController.clear();
    enterMessage = '';
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatInputController,
              decoration: InputDecoration(
                hintText: 'Send a message...',
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Colors.greenAccent),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.lime),
                    borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  enterMessage = value;
                });
              },
            ),
          ),
          // _chatInputController.text.isEmpty
          //     ? IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up))
          //     :
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: enterMessage.isEmpty ? null : _sendMessage,
              icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
