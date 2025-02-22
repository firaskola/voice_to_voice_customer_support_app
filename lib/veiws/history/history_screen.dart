import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversai/app/constants/constants.dart';
import 'package:conversai/utils/custom_nav_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatHistoryPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Chat History"),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).primaryColorLight,
        ),
        body: Center(child: Text("Please log in to view chat history.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat History",
          style: TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: kPrimaryLightColor,
      ),
      drawer: NavDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("users")
            .doc(_user!.uid)
            .collection("chats")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No chat history found."));
          }

          var chats = snapshot.data!.docs;

          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              var chat = chats[index];

              return Dismissible(
                key: Key(chat.id),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: kPrimaryColor,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _firestore
                      .collection("users")
                      .doc(_user!.uid)
                      .collection("chats")
                      .doc(chat.id)
                      .delete();
                },
                child: FutureBuilder<QuerySnapshot>(
                  future: _firestore
                      .collection("users")
                      .doc(_user!.uid)
                      .collection("chats")
                      .doc(chat.id)
                      .collection("messages")
                      .orderBy("timestamp")
                      .limit(1)
                      .get(),
                  builder: (context, messageSnapshot) {
                    if (!messageSnapshot.hasData ||
                        messageSnapshot.data!.docs.isEmpty) {
                      return ListTile(
                        title: Text(
                          "Chat ${index + 1}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("No messages found"),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatDetailPage(chatId: chat.id),
                          ),
                        ),
                      );
                    }

                    var firstMessage = messageSnapshot.data!.docs.first;
                    String formattedDate = DateFormat('yyyy-MM-dd hh:mm')
                        .format((chat["createdAt"] as Timestamp).toDate());

                    return ListTile(
                      title: Text(
                        "Chat ${index + 1}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        firstMessage["message"] ?? "No message",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        formattedDate,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(chatId: chat.id),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatDetailPage extends StatelessWidget {
  final String chatId;

  ChatDetailPage({required this.chatId});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Details'),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'Please log in to view messages.',
            style: TextStyle(color: kPrimaryLightColor),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: const Text('Chat Details'),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No messages found.',
                style: TextStyle(color: kPrimaryLightColor),
              ),
            );
          }

          var messages = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var messageData = messages[index].data() as Map<String, dynamic>;
              String message = messageData['message'] ?? '';
              String role = messageData['role'] ?? 'user';

              bool isUser = role != 'assistant';

              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? kPrimaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: isUser ? Colors.white : kPrimaryColor,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
