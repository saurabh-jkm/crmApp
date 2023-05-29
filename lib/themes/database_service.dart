// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

/////// reference for our collections  ++++++++++++++++++++++++++++++++++++


  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference chatBoxCollection =
      FirebaseFirestore.instance.collection("chatbox");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");


/////// saving the userdata   +++++++++++++++++++++++++++++++++++++++++++++

  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

 /////// getting user data


  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  ///// get user groups  ++++++++++++++++++++++++++++++++++


  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  ///////// creating a group for chat  +++++++++++++++++++++++++++++++++++++++

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

  ////////// update the members  +++++++++++++++++++++++++++++++++++++++++

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }



 Future createChatBox(String userName, String id) async {
    DocumentReference chatboxDocumentReference = await chatBoxCollection.add({
      "userName": userName,
      "members": [],
      "chatboxId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

  ////////// update the members  +++++++++++++++++++++++++++++++++++++++++

    await chatboxDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "chatboxId": chatboxDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "chatbox":
          FieldValue.arrayUnion(["${chatboxDocumentReference.id}_$userName"])
    });
  }

  ///////////     getting the chats    of group  +++++++++++++++++++++

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

///////////   The name of admin who created Group  +++++++++++++++++++++

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  /////// get group members  name list  ++++++++++++++++++++++++++++++++++++
  
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  ////////// search  search individual group by group name  ++++++++++++++++++++++ 
  
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }


  ByUserName(String userName) {
    return chatBoxCollection.where("userName", isEqualTo: userName).get();
  }

  getallgrops() {
    return groupCollection;
  }

  //////// function -> bool  for join or not join in group+++++++++++++++++++++++++++ 


  Future<bool> isUserJoined(String groupName, String groupId, String userName) 
  async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } 
    else {
      return false;
    }
  }


/////////    toggling the group join/exit  +++++++++++++++++++++++++++++++++++++++


  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }


///////    send message  ++++++++++++++++++++++++++++++++++


  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
