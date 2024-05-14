import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:yamudacarpooling/Model/Message%20.dart';
import 'package:yamudacarpooling/Model/UserModel.dart';
import 'package:yamudacarpooling/Services/AuthService.dart';

class ChatService extends ChangeNotifier {
  // Firebase auth instance
  FirebaseAuth _auth = FirebaseAuth.instance;
  // Firestore instance
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // find the document
  String documentId = "";
  Future<void> getDocId(String routeName) async {
    await FirebaseFirestore.instance
        .collection("routes")
        .where("routeName", isEqualTo: routeName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((QueryDocumentSnapshot document) async {
        documentId = document.id;
      });
    });
  }

  // Send Message
  Future<void> sendMessage(
    String routeName,
    String messageContent,
    String timeStamp,
    DateTime now,
  ) async {
    // Get current user info
    final String currentuserId = _auth.currentUser!.uid;
    final String currentuserEmail = _auth.currentUser!.email.toString();

    var newMessageId = now.toString() + now.millisecondsSinceEpoch.toString();
    AuthServices authService = AuthServices();
    UserModel? user = await authService.getAppUser(_auth.currentUser!.uid);

    // Create a new message
    Message newMessage = Message(
      newMessageId,
      currentuserId,
      currentuserEmail,
      user!.username ?? "User",
      timeStamp,
      messageContent,
    );

    // Add new message
    await getDocId(routeName);
    await FirebaseFirestore.instance
        .collection("routes")
        .doc(documentId)
        .collection("Messages")
        .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String documentId) {
    debugPrint(documentId);

    return _firestore
        .collection("routes")
        .doc(documentId)
        .collection("Messages")
        .orderBy('messageId', descending: false)
        .snapshots();
  }
}
