import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  const Conversation({Key? key, required this.id, required this.username})
      : super(key: key);
  final String id;
  final String username;

  @override
  _ConversationState createState() => _ConversationState(id, username);
}

class _ConversationState extends State<Conversation> {
  String? id;
  String username;
  String conversation_id = '';
  var messageStream;
  TextEditingController _message = TextEditingController();
  final _key = GlobalKey<FormState>();
  _ConversationState(this.id, this.username);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialConversation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          conversation_id != ''
              ? StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('error=========' + snapshot.error.toString());
                    } else if (!snapshot.hasData || snapshot.data == 'null') {
                      return LinearProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return LinearProgressIndicator();
                    }
                    return SingleChildScrollView(
                      child: Column(children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                                mainAxisAlignment:
                                    snapshot.data!.docs[index]['from'] == id
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxHeight: 100),
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: snapshot.data!.docs[index]
                                                  ['from'] ==
                                              id
                                          ? Colors.teal[400]
                                          : Colors.grey[500],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      snapshot.data!.docs[index]['message']
                                          .toString()
                                          .trim(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          overflow: TextOverflow.visible),
                                    ),
                                  ),
                                ]);
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  controller: _message,
                                  decoration: InputDecoration(
                                      hintText: 'Enter new message',
                                      prefixIcon: Icon(Icons.create_sharp)),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  var id_1 =
                                      FirebaseAuth.instance.currentUser!.uid;
                                  if (conversation_id == '' ||
                                      conversation_id == null) {
                                    await FirebaseFirestore.instance
                                        .collection('conversation')
                                        .add({
                                      "between": [id_1, id]
                                    }).then((value) async {
                                      print(value.toString());
                                      await value.collection('messages').add({
                                        "message": _message.value.text,
                                        "from": id_1,
                                        "createdAt": DateTime.now()
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(id)
                                          .update({
                                        "conversations": [
                                          value
                                              .toString()
                                              .split('/')[1]
                                              .substring(
                                                  0,
                                                  value
                                                          .toString()
                                                          .split('/')[1]
                                                          .length -
                                                      1)
                                        ]
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(id_1)
                                          .update({
                                        "conversations": [
                                          value
                                              .toString()
                                              .split('/')[1]
                                              .substring(
                                                  0,
                                                  value
                                                          .toString()
                                                          .split('/')[1]
                                                          .length -
                                                      1)
                                        ]
                                      });
                                    });
                                    setState(() {
                                      initialConversation();
                                    });
                                  } else {
                                    print('====================');
                                    await FirebaseFirestore.instance
                                        .collection('conversation')
                                        .doc(conversation_id)
                                        .collection('messages')
                                        .add({
                                      "message": _message.value.text,
                                      "from": id_1,
                                      "createdAt": DateTime.now()
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                      ]),
                    );
                  },
                )
              : Center(
                  // child: Text('write some thing to start conversation'),
                  ),
        ]),
      ),
      // bottomNavigationBar: Row(
      //   children: [
      //     Expanded(
      //       child: Container(
      //         child: TextFormField(
      //           controller: _message,
      //           decoration: InputDecoration(
      //               hintText: 'Enter new message',
      //               prefixIcon: Icon(Icons.create_sharp)),
      //         ),
      //       ),
      //     ),
      //     IconButton(
      //         onPressed: () async {
      //           var id_1 = FirebaseAuth.instance.currentUser!.uid;
      //           if (conversation_id == '' || conversation_id == null) {
      //             await FirebaseFirestore.instance
      //                 .collection('conversation')
      //                 .add({
      //               "between": [id_1, id]
      //             }).then((value) async {
      //               print(value.toString());
      //               await value.collection('messages').add({
      //                 "message": _message.value.text,
      //                 "from": id_1,
      //                 "createdAt": DateTime.now()
      //               });
      //               await FirebaseFirestore.instance
      //                   .collection('users')
      //                   .doc(id)
      //                   .update({
      //                 "conversations": [
      //                   value.toString().split('/')[1].substring(
      //                       0, value.toString().split('/')[1].length - 1)
      //                 ]
      //               });
      //               await FirebaseFirestore.instance
      //                   .collection('users')
      //                   .doc(id_1)
      //                   .update({
      //                 "conversations": [
      //                   value.toString().split('/')[1].substring(
      //                       0, value.toString().split('/')[1].length - 1)
      //                 ]
      //               });
      //             });
      //             setState(() {
      //               initialConversation();
      //             });
      //           } else {
      //             print('====================');
      //             await FirebaseFirestore.instance
      //                 .collection('conversation')
      //                 .doc(conversation_id)
      //                 .collection('messages')
      //                 .add({
      //               "message": _message.value.text,
      //               "from": id_1,
      //               "createdAt": DateTime.now()
      //             });
      //           }
      //         },
      //         icon: Icon(
      //           Icons.send,
      //           color: Colors.blue,
      //         ))
      //   ],
      // ),
    );
  }

  Future<bool> checkConversation() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print(value.toString());
    });
    return true;
  }

  Future<String> initialConversation() async {
    String conversation_idd = '';
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var i = 0; i < (userSnapshot['conversations'] as List).length; i++) {
        var conv = await FirebaseFirestore.instance
            .collection('conversation')
            .doc((userSnapshot['conversations'] as List)[i])
            .get();
        if ((conv['between'] as List).contains(id)) {
          conversation_idd = (userSnapshot['conversations'] as List)[i];
          setState(() {
            conversation_id = conversation_idd;
            messageStream = FirebaseFirestore.instance
                .collection('conversation')
                .doc(conversation_id)
                .collection('messages')
                .orderBy('createdAt')
                .snapshots();
          });
        }
      }
    } catch (e) {}
    print('===========================' + conversation_id.toString());
    return conversation_idd;
  }
}
