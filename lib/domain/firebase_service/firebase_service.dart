import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:quikapp/data/user_model.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel userDetails) async {
    try {
      await firestore
          .collection('users')
          .doc(userDetails.id)
          .set(userDetails.toJson());
      print('User created successfully!');
    } catch (e) {
      if (kDebugMode) {
        print('Error creating users: $e');
      }
    }
  }

  Future<bool> isUserExists(String userId) async {
    try {
      var doc = await firestore.collection('users').doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking userId existence: $e');
      return false;
    }
  }

  Future<bool> deleteConnection(String userId, String connectionId) async {
    try {
      /// Get a reference to the connection document
      DocumentReference connectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('connections')
          .doc(connectionId);
      print('print userId ${userId} ');
      print('print connectionId delete  ${connectionId} ');

      /// Delete the connection document
      await connectionRef.delete();
      return true;
    } catch (e) {
      print('Error deleting connection: $e');
      return false;
    }
  }

  Future<bool> updateUsersDetail(
      String userId, Map<String, dynamic> updateProfileDetails) async {
    try {
      // Get a reference to the connection document
      DocumentReference connectionRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      // Fetch existing data
      DocumentSnapshot snapshot = await connectionRef.get();
      if (snapshot.exists) {
        // Merge existing data with update data
        Map<String, dynamic> existingData =
            snapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> mergedData = {
          ...existingData,
          ...updateProfileDetails
        };
        // Update the connection details with merge option
        await connectionRef.set(mergedData, SetOptions(merge: true));
        // Print all the updated data
        print('Updated data: $mergedData');
      } else {
        print('Document does not exist');
        return false;
      }

      return true;
    } catch (e) {
      print('Error updating connection: $e');
      return false;
    }
  }

  Future<bool> checkIfUserExistsInDatabase(String uid) async {
    try {
      // Replace 'users' with the actual collection name in your Firestore database.
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userSnapshot.exists;
    } catch (e) {
      print('Error checking user existence in the database: $e');
      return false;
    }
  }

  Future<void> deleteUserAndStoreDeleteUsersCollection() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        DocumentSnapshot userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          // Copy the user document to the 'deleted-users' collection
          await FirebaseFirestore.instance
              .collection('deleted-users')
              .doc(user.uid)
              .set({
            ...userSnapshot.data() as Map<String, dynamic>,
            'deletedAt': DateTime.now().toString(),
          });

          // Get all documents in the user's subcollections
          QuerySnapshot connectionsSnapshot =
              await userRef.collection('connections').get();

          // Delete each document in the subcollections
          for (QueryDocumentSnapshot connectionDoc
              in connectionsSnapshot.docs) {
            await connectionDoc.reference.delete();
          }

          // Delete the user document itself
          await userRef.delete();

          // Finally, delete the user from Firebase Authentication
          await user.delete();
        }
      }
    } catch (e) {
      print('Error deleting user: $e');
      // Handle any errors that occur during deletion
    }
  }

  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot docSnapshot =
          await firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print('Worker Data Not Found');
        return null;
      }
    } catch (e) {
      print('Error Retrieving Worker $e ');
      return null;
    }
  }

  Future<void> updateUserData(String userid, UserModel userdata) async {
    try {
      // Get a reference to the user document in Firestore
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userid);

      // Update the user document with the new data
      await userRef.update(userdata.toJson());
    } catch (e) {
      print('Failed to update user data in Firebase: $e');
      throw e; // Optionally, you can rethrow the exception to handle it elsewhere
    }
  }
}
