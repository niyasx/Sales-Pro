import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sales_management_app/core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FlutterSecureStorage secureStorage;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.secureStorage,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // Sign in with Firebase Auth
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Login failed');
      }

      // Get user data from Firestore
      final userDoc = await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException('User data not found');
      }

      // Get token
      final token = await credential.user!.getIdToken();

      // Save token securely
      if (token != null) {
        await secureStorage.write(key: 'auth_token', value: token);
      }

      final userData = userDoc.data()!;
      return UserModel(
        id: credential.user!.uid,
        email: userData['email'] as String,
        name: userData['name'] as String,
        token: token,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      await secureStorage.delete(key: 'auth_token');
    } catch (e) {
      throw AuthException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      
      if (currentUser == null) {
        return null;
      }

      final userDoc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      final token = await secureStorage.read(key: 'auth_token');
      final userData = userDoc.data()!;

      return UserModel(
        id: currentUser.uid,
        email: userData['email'] as String,
        name: userData['name'] as String,
        token: token,
      );
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }
}