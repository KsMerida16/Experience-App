import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_app/feature/auth/domain/entities/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final credentials = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _buildAppUser(credentials.user!);
  }

  Future<AppUser> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final credentials = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(credentials.user!.uid).set({
      'email': email,
      'name': name ?? '',
      'role': 'user',
    });

    return AppUser(uid: credentials.user!.uid, email: email, role: 'user');
  }

  Future<void> signOut() => _auth.signOut();
  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _buildAppUser(user);
  }

  Future<AppUser> _buildAppUser(User firebaseUser) async {
    final doc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    final role = doc.data()?['role'] ?? 'user';
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      role: role,
    );
  }
}
