import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:spots_msp_project/shared/components/constants.dart';

import '../../shared/components/components.dart';
import 'chat.dart';
import 'package:cached_network_image/cached_network_image.dart';

class chats extends StatefulWidget {
  int eventId;

  chats({required this.eventId});

  @override
  State<chats> createState() => _chatsState();
}

class _chatsState extends State<chats> {
  List allUsers = [];
  List results = [];
  List usersId = [];
  bool load = false;
  TextEditingController searchController = TextEditingController();

  Future<void> getData() async {
    setState(() {
      load = true;
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .snapshots()
        .listen((value) {
      for (var userr in value.docs) {
        if (userr.data()['Email'] != FirebaseAuth.instance.currentUser?.email) {
          if (!usersId.contains(userr.data()['userid'])) {
            if (widget.eventId.toInt() == 11111.toInt()) {
              setState(() {
                usersId.add(userr.data()['userid']);
                allUsers.add(userr.data());
              });
            }else if (userr['EnrolledEvents'].contains(widget.eventId)) {
              setState(() {
                usersId.add(userr.data()['userid']);
                allUsers.add(userr.data());
              });
            }
          }
          setState(() {
            results = allUsers;
          });



        }
      }
    });

    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    load = true;
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
            child: Text(
          'Spots',
          style: TextStyle(color: Colors.white),
        )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: load
          ? Center(
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Loading...",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Chats",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[300],
                      ),
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  results = searchController.text.isEmpty
                                      ? allUsers
                                      : allUsers
                                          .where((element) => element['Name']
                                              .startsWith(RegExp(
                                                  searchController.text,
                                                  caseSensitive: false)))
                                          .toList();
                                });
                              },
                              controller: searchController,
                              maxLines: 1,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(results[index]['Image']),
                          ),
                          title: Text(results[index]['Name']),
                          subtitle: Text(results[index]['Email']),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => chat(
                                          name: results[index]['Name'],
                                          photo: results[index]['Image'],
                                          UID: results[index]['userid'],
                                        )));
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
