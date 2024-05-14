import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageService extends ChangeNotifier {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> uploadImage(File? image) async {
    if (image == null) {
      print("Image is null");
      return null;
    }

    try {
      var imageName = '${FirebaseAuth.instance.currentUser!.uid}profile';
      var storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$imageName.jpg');
      try {
        await storageRef.getMetadata();
        // If the code reaches here, it means the image exists, so delete it
        await storageRef.delete();
        print("Old image deleted");
      } catch (e) {
        // Image does not exist, or there was an error (which means it does not exist)
        print("Image does not exist or error: $e");
      }

      var uploadTask = storageRef.putFile(image);
      var snapshot =
          await uploadTask.whenComplete(() => print("Upload complete"));

      var downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

// vehicles image

  Future<String?> uploadVehicleImage(File? image, String reg) async {
    if (image == null) {
      print("Image is null");
      return null;
    }

    try {
      String imageName = FirebaseAuth.instance.currentUser!.uid +
          reg +
          DateTime.now().toString();
      var storageRef =
          FirebaseStorage.instance.ref().child('vehicle_images/$imageName.jpg');
      try {
        await storageRef.getMetadata();
        // If the code reaches here, it means the image exists, so delete it
        await storageRef.delete();
        print("Old image deleted");
      } catch (e) {
        // Image does not exist, or there was an error (which means it does not exist)
        print("Image does not exist or error: $e");
      }

      var uploadTask = storageRef.putFile(image);
      var snapshot =
          await uploadTask.whenComplete(() => print("Upload complete"));

      var downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
