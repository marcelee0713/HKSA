import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hksa/constant/string.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> changeScholarPfp(String filePath, fileName, userID, oldPic,
      VoidCallback showDialog) async {
    File file = File(filePath);
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/Scholars/$userID/profilePicture");
    try {
      Reference ref = storage.ref('users/scholars/$userID/pfp/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      uploadTask.then((res) async {
        debugPrint(await res.ref.getDownloadURL());
        await dbReference.set(await res.ref.getDownloadURL());
        // Now delete the old picture, but not the default
        if (FirebaseStorage.instance.refFromURL(oldPic) !=
            FirebaseStorage.instance.refFromURL(HKSAStrings.pfpPlaceholder)) {
          await FirebaseStorage.instance.refFromURL(oldPic).delete();
        }

        showDialog();
      });
    } on firebase_core.FirebaseException {
      rethrow;
    }
  }

  Future<void> changeProfPfp(String filePath, fileName, userID, oldPic,
      VoidCallback showDialog) async {
    File file = File(filePath);
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/Professors/$userID/profilePicture");
    try {
      Reference ref = storage.ref('users/professors/$userID/pfp/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      uploadTask.then((res) async {
        debugPrint(await res.ref.getDownloadURL());
        await dbReference.set(await res.ref.getDownloadURL());
        // Now delete the old picture, but not the default
        if (FirebaseStorage.instance.refFromURL(oldPic) !=
            FirebaseStorage.instance.refFromURL(HKSAStrings.pfpPlaceholder)) {
          await FirebaseStorage.instance.refFromURL(oldPic).delete();
        }

        showDialog();
      });
    } on firebase_core.FirebaseException {
      rethrow;
    }
  }

  Future<void> changeHeadPfp(String filePath, fileName, userID, oldPic,
      VoidCallback showDialog) async {
    File file = File(filePath);
    DatabaseReference dbReference = FirebaseDatabase.instance
        .ref()
        .child("Users/Head/$userID/profilePicture");
    try {
      Reference ref = storage.ref('users/head/$userID/pfp/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      uploadTask.then((res) async {
        debugPrint(await res.ref.getDownloadURL());
        await dbReference.set(await res.ref.getDownloadURL());
        // Now delete the old picture, but not the default
        if (FirebaseStorage.instance.refFromURL(oldPic) !=
            FirebaseStorage.instance.refFromURL(HKSAStrings.pfpPlaceholder)) {
          await FirebaseStorage.instance.refFromURL(oldPic).delete();
        }

        showDialog();
      });
    } on firebase_core.FirebaseException {
      rethrow;
    }
  }
}
