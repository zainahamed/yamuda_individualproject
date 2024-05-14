import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Globle/Globle.dart';
import 'package:yamudacarpooling/Pages/HomePage.dart';
import 'package:yamudacarpooling/Services/ChatService.dart';
import 'package:yamudacarpooling/Widgets/MessageBubble.dart';
import 'package:yamudacarpooling/Widgets/SnackbarMessage.dart';

class ChatPage extends StatefulWidget {
  final routeName;
  final routeImage;
  final members;
  final routeID;
  final userId;
  const ChatPage(
      {super.key,
      this.routeName,
      this.routeImage,
      this.members,
      this.routeID,
      this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatService = ChatService();
  final _auth = FirebaseAuth.instance;
  ScrollController _scrollController = ScrollController();

  String documentId = "";
  Future<void> getDocId(String routeName) async {
    await FirebaseFirestore.instance
        .collection("routes")
        .where("routeName", isEqualTo: routeName)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((QueryDocumentSnapshot document) async {
        setState(() {
          documentId = document.id;
        });
      });
    });
  }

  void _showDeleteRouteDialog(BuildContext context) {
    String routeName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Route'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
                await FirebaseFirestore.instance
                    .collection('routes')
                    .doc(widget.routeID)
                    .delete();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _chatPage();
  }

  Scaffold _chatPage() {
    // create controller
    TextEditingController? messageContentController = TextEditingController();
    // create chateservice instance

    //send message
    void sendeMessage() async {
      if (messageContentController.text.isNotEmpty) {
        var now = DateTime.now();
        var formatterDate = DateFormat('dd/MM/yy');
        var formatterTime = DateFormat('kk:mm');
        String actualTime = formatterTime.format(now);

        await chatService.sendMessage(
            widget.routeName, messageContentController.text, actualTime, now);
        messageContentController.clear();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bubbleColor2,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.routeName,
            style: TextStyle(fontSize: 18, color: Secondary),
          ),
        ]),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
                onPressed: () {
                  if (widget.userId != currentuser.uid) {
                    SnackBarMessage.showSnackBarError(
                        context, "Your are Not the owner of this chat");
                    return;
                  }
                  _showDeleteRouteDialog(context);
                },
                icon: Icon(
                  Icons.delete,
                  color: Secondary,
                )),
          )
        ],
      ),
      body: Stack(children: [
        //Message List
        Column(
          children: [
            Expanded(child: _buildMessageList()),
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            )
          ],
        ),
        const Align(
          alignment: Alignment.center,
        ),

        //Message Box
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 100),
                    decoration: BoxDecoration(
                        color: bubbleColor2,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      maxLines: null,
                      controller: messageContentController,
                      style: const TextStyle(color: Secondary),
                      cursorColor: Secondary,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write your message",
                        hintStyle: TextStyle(color: Secondary),
                        labelStyle: TextStyle(color: Colors.blue), // Text color
                        // Add a hint text
                        prefixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.keyboard,
                            color: Secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // send button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: bubbleColor2),
                    child: IconButton(
                        onPressed: sendeMessage,
                        icon: Icon(
                          Icons.send,
                          color: Secondary,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessages(widget.routeID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Primary,
              size: 40,
            ),
          );
        }
        //To get scroll to down
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _bildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _bildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    debugPrint(data.toString());
    bool isMe = false;

    //aligmnet of message
    var allignment = (data["senderId"] == _auth.currentUser!.uid)
        ? isMe = true
        : isMe = false;

    return Container(
        child: Column(
      children: [
        MessageBubble(
            sender: data['senderUserName'] ?? "App user",
            content: data['content'],
            time: data['timeSpan'],
            isMe: isMe),
      ],
    ));
  }
}
