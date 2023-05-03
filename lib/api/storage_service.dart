import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hksa/constant/string.dart';
import 'package:hksa/models/scholar.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> createScholar(
    String filePath,
    fileName,
    studentNumber,
    name,
    course,
    email,
    phoneNumber,
    password,
    hkType,
    hours,
    status,
    totalHoursInDisplay,
    totalHoursInDuration,
    totalHoursRequired,
    isFinished,
    onSiteDay1,
    onSiteDay2,
    vacantTimeDay1,
    vacantTimeDay2,
    wholeDayVacantTime,
    scholarType,
    town,
  ) async {
    File file = File(filePath);
    DatabaseReference dbReference =
        FirebaseDatabase.instance.ref().child("Users/Scholars/");
    try {
      Reference ref =
          storage.ref('users/scholars/$studentNumber/pfp/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      uploadTask.then((res) async {
        String pfp = await res.ref.getDownloadURL();
        if (hkType == "HK25") {
          totalHoursRequired = "60";
        } else if (hkType == "HK50" || hkType == "HK75") {
          totalHoursRequired = "90";
        }
        Scholar scholarObj = Scholar(
          studentNumber: studentNumber,
          name: name,
          course: course,
          email: email,
          phonenumber: phoneNumber,
          password: password,
          hkType: hkType,
          hours: hours,
          status: status,
          totalHoursInDisplay: totalHoursInDisplay,
          totalHoursInDuration: totalHoursInDuration,
          totalHoursRequired: totalHoursRequired,
          isFinished: isFinished,
          profilePicture: pfp,
          onSiteDay1: onSiteDay1,
          onSiteDay2: onSiteDay2,
          vacantTimeDay1: vacantTimeDay1,
          vacantTimeDay2: vacantTimeDay2,
          wholeDayVacantTime: wholeDayVacantTime,
          scholarType: scholarType,
          town: town,
          assignedProfD1: '',
          assignedProfD2: '',
          assignedProfWd: '',
          listeningTo: '',
        );

        await dbReference.child(studentNumber).set(scholarObj.toJson());
      });
    } on firebase_core.FirebaseException {
      rethrow;
    }
  }

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
