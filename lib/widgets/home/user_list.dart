// lib/widgets/home/user_list.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserList extends StatelessWidget {
  Future<void> _updateFollowStatus(String uid, bool isFollow) async {
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("followFrom")
        .doc(FirebaseAuth.instance.currentUser.uid);
    final doc = await docRef.get();
    if (isFollow) {
      docRef.delete();
    } else {
      docRef.set({
        "isFollowing": true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userDocs = snapshot.data.docs;
        return ListView.builder(
          itemCount: userDocs.length,
          itemBuilder: (cx, index) {
            var userFollower = [];
            if (userDocs[index].data().containsKey("follower")) {
              userFollower = userDocs[index].get("follower");
            }
            return ListTile(
              title: Text(userDocs[index].get("email")),
              trailing: IconButton(
                icon: Icon(
                  userFollower.contains(FirebaseAuth.instance.currentUser.uid)
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  color: Colors.pink,
                ),
                onPressed: () {
                  _updateFollowStatus(
                      userDocs[index].id,
                      userFollower
                          .contains(FirebaseAuth.instance.currentUser.uid));
                },
              ),
            );
          },
        );
      },
    );
  }
}
