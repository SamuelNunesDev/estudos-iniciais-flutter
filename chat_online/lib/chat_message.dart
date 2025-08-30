import 'package:chat_online/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(this.data, {super.key});

  final Map<String, dynamic> data;
  late final User? user;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FirebaseService>().user;
    final bool fromLoggedUser = user?.uid == data["uid"];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          fromLoggedUser
              ? Container()
              : CircleAvatar(
                  backgroundImage: NetworkImage(data["senderPhoto"]),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: fromLoggedUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                data["url"] != null
                    ? BubbleNormalImage(
                        id: data['url'],
                        image: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(data["url"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        tail: true,
                        isSender: fromLoggedUser,
                        color: Color(0xFF1B97F3),
                      )
                    : BubbleSpecialThree(
                        text: data["text"],
                        color: fromLoggedUser
                            ? Color(0xFF1B97F3)
                            : Color(0xFFE0E0E0),
                        textStyle: TextStyle(
                          color: fromLoggedUser ? Colors.white : Colors.black,
                          fontSize: 18,
                        ),
                        isSender: fromLoggedUser,
                      ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 2, left: 8),
                  child: Text(
                    data["senderName"],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          fromLoggedUser
              ? CircleAvatar(backgroundImage: NetworkImage(data["senderPhoto"]))
              : Container(),
        ],
      ),
    );
  }
}
