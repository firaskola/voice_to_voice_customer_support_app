import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new chat and return its ID
  Future<String> createNewChat(String uid) async {
    final chatRef =
        await _firestore.collection('users').doc(uid).collection('chats').add({
      'createdAt': FieldValue.serverTimestamp(), // Timestamp for sorting
    });
    return chatRef.id; // Return the chat ID
  }

  // Add a message (prompt or response) to a chat
  Future<void> addMessage(
      String uid, String chatId, String role, String message) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'role': role,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Fetch all chat IDs for a user
  Future<List<String>> getChatIds(String uid) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .orderBy('createdAt', descending: true) // Sort by latest first
        .get();
    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  // Fetch all messages for a specific chat
  Future<List<Map<String, dynamic>>> getChatMessages(
      String uid, String chatId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp') // Sort by timestamp
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fetch user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null; // Return null if no data found
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
