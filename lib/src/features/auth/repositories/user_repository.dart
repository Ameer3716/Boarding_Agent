import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'users';

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection(_collection).doc(user.id).set(user.toFirestore());
    } catch (e) {
      throw 'Failed to create user profile: ${e.toString()}';
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch user: ${e.toString()}';
    }
  }

  Stream<UserModel?> getUserStream(String userId) {
    try {
      return _firestore
          .collection(_collection)
          .doc(userId)
          .snapshots()
          .map((doc) {
        if (doc.exists && doc.data() != null) {
          return UserModel.fromFirestore(doc);
        }
        return null;
      });
    } catch (e) {
      throw 'Failed to get user stream: ${e.toString()}';
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.id)
          .update(user.toFirestore());
    } catch (e) {
      throw 'Failed to update user: ${e.toString()}';
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).delete();
    } catch (e) {
      throw 'Failed to delete user: ${e.toString()}';
    }
  }

  Future<List<UserModel>> getTopUsers({int limit = 10}) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .orderBy('totalPoints', descending: true)
          .limit(limit)
          .get();

      return query.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to fetch top users: ${e.toString()}';
    }
  }

  Future<void> updateUserPoints(String userId, int points) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'totalPoints': FieldValue.increment(points),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update user points: ${e.toString()}';
    }
  }

  Future<void> updateOnboardingStatus(String userId, bool isComplete) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'isOnboardingComplete': isComplete,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update onboarding status: ${e.toString()}';
    }
  }

  // Add the missing completeOnboarding method
  Future<void> completeOnboarding(String userId, Map<String, dynamic> onboardingData) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'agency': onboardingData['agency'],
        'location': onboardingData['location'],
        'experienceLevel': onboardingData['experienceLevel'],
        'isOnboardingComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to complete onboarding: ${e.toString()}';
    }
  }
}