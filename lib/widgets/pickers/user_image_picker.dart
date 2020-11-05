// lib/widgets/pickers/user_image_picker.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this._oldImageUrl);
  final String _oldImageUrl;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    _uploadAndSet();
  }

  Future<void> _uploadAndSet() async {
    try {
      setState(() {
        _isLoading = true;
      });
      // 画像をアップロードしてURLを取得
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(DateTime.now().toIso8601String() + '.jpg');
      await ref.putFile(_pickedImage).onComplete;
      final url = await ref.getDownloadURL();
      // 古いものを削除してからFirestoreに登録
      if (widget._oldImageUrl.isNotEmpty) {
        final oldRef = await FirebaseStorage.instance
            .getReferenceFromUrl(widget._oldImageUrl);
        await oldRef.delete();
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'imageUrl': url,
      });
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials!';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text(
              "pick profile image",
            ),
          );
  }
}
