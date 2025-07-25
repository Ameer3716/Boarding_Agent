import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final String? agency;
  final String? location;
  final String experienceLevel;
  final String role;
  final int totalPoints;
  final int rank;
  final bool isBlackcardMember;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isOnboardingComplete;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.agency,
    this.location,
    required this.experienceLevel,
    required this.role,
    required this.totalPoints,
    required this.rank,
    required this.isBlackcardMember,
    required this.createdAt,
    required this.updatedAt,
    required this.isOnboardingComplete,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'],
      agency: data['agency'],
      location: data['location'],
      experienceLevel: data['experienceLevel'] ?? 'beginner',
      role: data['role'] ?? 'regular',
      totalPoints: data['totalPoints'] ?? 0,
      rank: data['rank'] ?? 0,
      isBlackcardMember: data['isBlackcardMember'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isOnboardingComplete: data['isOnboardingComplete'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'agency': agency,
      'location': location,
      'experienceLevel': experienceLevel,
      'role': role,
      'totalPoints': totalPoints,
      'rank': rank,
      'isBlackcardMember': isBlackcardMember,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isOnboardingComplete': isOnboardingComplete,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    String? agency,
    String? location,
    String? experienceLevel,
    String? role,
    int? totalPoints,
    int? rank,
    bool? isBlackcardMember,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isOnboardingComplete,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      agency: agency ?? this.agency,
      location: location ?? this.location,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      role: role ?? this.role,
      totalPoints: totalPoints ?? this.totalPoints,
      rank: rank ?? this.rank,
      isBlackcardMember: isBlackcardMember ?? this.isBlackcardMember,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoURL,
    agency,
    location,
    experienceLevel,
    role,
    totalPoints,
    rank,
    isBlackcardMember,
    createdAt,
    updatedAt,
    isOnboardingComplete,
  ];
}