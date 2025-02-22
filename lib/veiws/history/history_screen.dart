import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conversai/utils/custom_nav_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatHistoryPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Chat History")),
        body: Center(child: Text("Please log in to view chat history.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Chat History")),
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

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];
              return FutureBuilder<QuerySnapshot>(
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
                      title: Text("Chat ${index + 1}"),
                      subtitle: Text("No messages found"),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(chatId: chat.id),
                        ),
                      ),
                    );
                  }

                  var firstMessage = messageSnapshot.data!.docs.first;
                  return ListTile(
                    title: Text("Chat ${index + 1}"),
                    subtitle: Text(firstMessage["message"] ?? "No message"),
                    trailing: Text(
                      (chat["createdAt"] as Timestamp).toDate().toString(),
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
        appBar: AppBar(title: Text('Chat Details')),
        body: Center(child: Text('Please log in to view messages.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chat Details')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users') // ✅ Fetching from correct path
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
            return const Center(child: Text('No messages found.'));
          }

          var messages = snapshot.data!.docs;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var messageData = messages[index].data() as Map<String, dynamic>;
              String message = messageData['message'] ?? '';
              String role = messageData['role'] ?? 'user';

              return Align(
                alignment: role == 'assistant'
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: role == 'assistant'
                        ? Colors.grey[300]
                        : Colors.blue[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 16),
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
