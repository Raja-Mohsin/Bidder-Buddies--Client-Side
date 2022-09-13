import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/order_message.dart';
import '../widgets/order_msg_chat_bubble.dart';

class OrderChatWidget extends StatefulWidget {
  final String orderId;

  const OrderChatWidget(this.orderId, {Key? key}) : super(key: key);

  @override
  State<OrderChatWidget> createState() => _OrderChatWidgetState();
}

class _OrderChatWidgetState extends State<OrderChatWidget> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Uuid uuid = const Uuid();
  List<OrderMessage> messages = [];
  bool isLoading = false;
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final String currentUserKey = firebaseAuth.currentUser!.uid;
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return Column(
      children: [
        StreamBuilder(
          stream: firebaseFirestore
              .collection('orders')
              .doc(widget.orderId)
              .collection('chat')
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
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                    'Nothing to show, send some messages to show them here.'),
              );
            }
            messages.clear();
            snapshot.data!.docs.forEach(
              (msg) {
                messages.add(
                  OrderMessage(
                    msg['id'],
                    msg['orderId'],
                    msg['senderId'],
                    msg['recieverId'],
                    msg['content'],
                    msg['timestamp'],
                  ),
                );
              },
            );
            return Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return OrderMsgChatBubble(
                    messages[index].senderId == currentUserKey ? true : false,
                    messages[index].content,
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
    //query to be fixed
    await firebaseFirestore
        .collection('orders')
        .doc(widget.orderId)
        .collection('chat')
        .doc(id)
        .set(
      {
        'id': id,
        'orderId': widget.orderId,
        'senderId': currentUserKey,
        'recieverId': '',
        'content': content,
        'timestamp': timestamp,
      },
    );
  }
}
