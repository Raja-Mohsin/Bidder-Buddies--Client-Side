import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class MessageBubble extends StatefulWidget {
  final bool isYourMessage;
  final String senderName;
  final String content;
  final String imageUrl;
  final String senderId;

  const MessageBubble(this.isYourMessage, this.senderName, this.content,
      this.imageUrl, this.senderId,
      {Key? key})
      : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController reportMessageController = TextEditingController();
  Uuid uuid = const Uuid();
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    String currentUserKey = firebaseAuth.currentUser!.uid.toString();
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    return Card(
      color: widget.isYourMessage ? theme.primaryColor : Colors.white,
      elevation: 0.5,
      margin: EdgeInsets.only(
        left: widget.isYourMessage ? bodyWidth * 0.1 : 15,
        right: widget.isYourMessage ? 15 : bodyWidth * 0.1,
        top: 12,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.imageUrl,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.senderName,
                      style: TextStyle(
                          color: widget.isYourMessage
                              ? Colors.white
                              : theme.primaryColor),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      width: bodyWidth * 0.6,
                      child: Text(
                        widget.content,
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isYourMessage
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                //pop up menu icon button
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    showPopupMenu(
                      context,
                      details.globalPosition,
                      currentUserKey,
                      widget.senderId,
                      widget.content,
                    );
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: widget.isYourMessage
                        ? Colors.white
                        : theme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
          topRight:
              widget.isYourMessage ? Radius.zero : const Radius.circular(18),
          topLeft:
              widget.isYourMessage ? const Radius.circular(18) : Radius.zero,
        ),
      ),
    );
  }

  //function to show pop up menu when icon button is clicked
  Future<void> showPopupMenu(
    BuildContext ctx,
    Offset offset,
    String currentUserKey,
    String senderId,
    String content,
  ) async {
    ThemeData theme = Theme.of(context);
    MediaQueryData media = MediaQuery.of(context);
    double bodyWidth = media.size.width - media.padding.top;
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
          child: const Text('Report this message'),
          value: 'report',
          onTap: () {
            //open dialog for getting the reason of report
            Future.delayed(
              const Duration(seconds: 0),
              () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Report a Message'),
                  actions: [
                    //cancel button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    //submit report button
                    ElevatedButton(
                      onPressed: () async {
                        String validationResult = validation();
                        if (validationResult == 'No Error') {
                          //close the dialog
                          Navigator.of(context).pop();
                          //submit the report
                          await submitReport(
                            currentUserKey,
                            senderId,
                            reportMessageController.text.toString(),
                            'chat',
                            content,
                          );
                        } else {
                          //close the dialog
                          Navigator.of(context).pop();
                          // show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(validationResult),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: theme.textTheme.bodyText1!.fontFamily,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(bodyWidth * 0.35, 35),
                        primary: theme.primaryColor,
                        elevation: 10,
                      ),
                    ),
                  ],
                  //text field for reason input
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Enter reason for reporting'),
                      const SizedBox(height: 10),
                      TextField(
                        controller: reportMessageController,
                        maxLength: 50,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter here..',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
      elevation: 8.0,
    );
  }

  Future<void> submitReport(
    String from,
    String to,
    String userText,
    String systemText,
    String content,
  ) async {
    //create id, date and time
    String id = uuid.v4().toString();
    final String date = formatter.format(now);
    final String time = "${now.hour}:${now.minute}:${now.second}";
    //send in database
    await firebaseFirestore.collection('reports').doc(id).set(
      {
        'id': id,
        'from': from,
        'to': to,
        'systemComment': systemText,
        'userComment': userText,
        'content': content,
        'date': date,
        'time': time,
      },
    );
    //show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Report submitted successfully, thanks for your feedback, we will review this report shortly.'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  String validation() {
    if (reportMessageController.text.isEmpty) {
      return 'Enter a valid reason for the report';
    }
    if (reportMessageController.text.length < 10) {
      return 'Reason too short, explain briefly';
    }
    return 'No Error';
  }
}
