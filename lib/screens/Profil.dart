import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _user;
  String _username = "";
  String _phoneNumber = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      try {
        // Mengambil email pengguna yang saat ini masuk
        String email = _user!.email ?? "";
        
        // Mencari dokumen di Firestore berdasarkan email pengguna
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('UserList')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        // Jika ditemukan dokumen, ambil data
        if (querySnapshot.docs.isNotEmpty) {
          var userData = querySnapshot.docs.first.data();
          setState(() {
            _username = userData['fullname'] ?? "";
            _phoneNumber = userData['phoneNumber'] ?? "";
          });
          print("Username: $_username, PhoneNumber: $_phoneNumber");
        }
      } catch (e) {
        print("Error loading user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/tokobukusederhana-a4538.appspot.com/o/profil%2Fnot-profile-gray_02.jpg?alt=media&token=1849c3e6-99e7-45ae-9fb5-06d81de24d72"),
            ),
            SizedBox(height: 20),
            Text(
              _username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            UserInfoTile(
              icon: Icons.email,
              title: _user?.email ?? '',
            ),
            UserInfoTile(
              icon: Icons.phone,
              title: _phoneNumber,
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const UserInfoTile({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }
}
