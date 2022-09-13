import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';

class AuctionChatWidget extends StatefulWidget {
  final String auctionId;
  const AuctionChatWidget(this.auctionId, {Key? key}) : super(key: key);

  @override
  State<AuctionChatWidget> createState() => _AuctionChatWidgetState();
}

class _AuctionChatWidgetState extends State<AuctionChatWidget> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Uuid uuid = const Uuid();
  List<ChatMessage> messages = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final String currentUserKey = firebaseAuth.currentUser!.uid;
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;

    TextEditingController messageController = TextEditingController();
    FocusNode messageFocusNode = FocusNode();
    return Column(
      children: [
        StreamBuilder(
          stream: firebaseFirestore
              .collection('ChatMsgs')
              .where('auctionId', isEqualTo: widget.auctionId)
              .orderBy('timestamp', descending: true)
              .limit(500)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              );
            }
            messages.clear();
            snapshot.data!.docs.forEach(
              (msg) {
                messages.add(
                  ChatMessage(
                    msg['id'],
                    msg['senderId'],
                    msg['auctionId'],
                    msg['senderName'],
                    msg['imageUrl'],
                    msg['content'],
                    msg['timestamp'],
                  ),
                );
              },
            );
            return Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return MessageBubble(
                    messages[index].senderId == currentUserKey ? true : false,
                    messages[index].senderName,
                    messages[index].content,
                    messages[index].imageUrl,
                    messages[index].senderId,
                  );
                },
                itemCount: messages.length,
                reverse: true,
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                child: TextField(
                  cursorColor: theme.primaryColor,
                  cursorHeight: 22,
                  controller: messageController,
                  focusNode: messageFocusNode,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Type Message..',
                  ),
                ),
                width: bodyWidth * 0.8,
              ),
              IconButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        String validationResult =
                            validation(messageController.text.toString());
                        if (validationResult == 'No Error') {
                          //set to loading
                          setState(() {
                            isLoading = true;
                          });
                          //call the function
                          await sendMsgToDatabase(
                            currentUserKey,
                            messageController.text.toString(),
                          );
                          setState(() {
                            isLoading = false;
                          });
                          //clear the text field and remove focus from it
                          messageController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(validationResult),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                icon: Icon(
                  Icons.send,
                  color: isLoading ? Colors.grey : theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String validation(String msg) {
    if (msg.isEmpty) {
      return 'Message can\'t be empty';
    }
    return 'No Error';
  }

  Future<void> sendMsgToDatabase(String currentUserKey, String content) async {
    String id = uuid.v4();
    //timestamp
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    //fetch sender name and image url
    String senderName = '';
    String senderImageUrl = '';
    await firebaseFirestore.collection('users').doc(currentUserKey).get().then(
      (DocumentSnapshot snapshot) async {
        Map<String, dynamic> fetchedUserMap =
            snapshot.data()! as Map<String, dynamic>;
        senderName = fetchedUserMap['name'].toString();
        senderImageUrl = fetchedUserMap['imageUrl'].toString();
        await firebaseFirestore.collection('ChatMsgs').doc(id).set(
          {
            'id': id,
            'senderId': currentUserKey,
            'auctionId': widget.auctionId,
            'senderName': senderName,
            'imageUrl': senderImageUrl,
            'content': content,
            'timestamp': timestamp,
          },
        );
      },
    );
  }
}
