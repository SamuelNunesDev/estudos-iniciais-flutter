import 'package:chat_online/chat_message.dart';
import 'package:chat_online/firebase_service.dart';
import 'package:chat_online/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<FirebaseService>().user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          user?.displayName != null ? "Olá, ${user.displayName}" : "Chat App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          user == null
              ? Container()
              : IconButton(
                  onPressed: () {
                    FirebaseService.instance.logout();
                  },
                  icon: Icon(Icons.exit_to_app),
                  color: Colors.white,
                ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseService.instance
                  .getStreamSnapshotsMessagesOrdered(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    List<DocumentSnapshot> documents =
                        snapshot.data?.docs.reversed.toList() ?? [];

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 0),
                        itemCount: documents.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final documentData =
                              documents[index].data() as Map<String, dynamic>;
                          return ChatMessage(documentData);
                        },
                      ),
                    );
                }
              },
            ),
          ),
          TextComposer(),
        ],
      ),
    );
  }
}
