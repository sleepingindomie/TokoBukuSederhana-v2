import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tokobukusederhana/screens/AddBook.dart';
import 'package:tokobukusederhana/screens/Home.dart';
import 'package:tokobukusederhana/screens/LoginPage.dart';
import 'package:tokobukusederhana/screens/Profil.dart';
import 'package:tokobukusederhana/services/firebase_auth_service.dart';

class LandingPage extends StatefulWidget {
  bool isLoggedIn;
  String? loggedInUsername;
  String? loggedInEmail;

  LandingPage({
    Key? key,
    required this.isLoggedIn,
    this.loggedInUsername,
    required this.loggedInEmail,
  }) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseAuthService _authService = FirebaseAuthService();
  late List<Map<String, dynamic>> books = [];
  int _selectedIndex = 0;

  List<Widget> _pages = [];

  List<String> categories = [
    "Pendidikan",
    "Novel",
    "Anak-Anak",
    "Biografi",
    "Bimbingan Belajar",
    "Bahasa Asing",
    "Komik",
  ];

  Future<QuerySnapshot<Map<String, dynamic>>> fetchData(String category) async {
    return FirebaseFirestore.instance.collection(category.toLowerCase()).get();
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    fetchBooks();
    _pages = [
      _buildHomePage(),
      ProfilePage(),
      AddBookPage(),
    ];
  }

  Future<void> _getUserDetails() async {
    User? user = await _authService.getCurrentUser();

    if (user != null) {
      setState(() {
        widget.loggedInEmail = user.email;
      });
    }
  }

  Future<void> fetchBooks() async {
    for (String category in categories) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fetchData(category);
      setState(() {
        books.addAll(querySnapshot.docs.map((doc) => doc.data()).toList());
      });
    }
  }

  Widget buildHomeContent() {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Toko Buku Sederhana',
        style: TextStyle(fontSize: 17.5),
      ),
      backgroundColor: Colors.orange[800],
    ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tambahkan kode UI dari widget Home di sini
          // Pastikan untuk menyesuaikan kontennya dengan tampilan yang diinginkan
        ],
      ),
    ),
  );
}

  Widget _buildHomePage() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigasi ke halaman Home saat tombol ditekan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          child: Text('Lihat Buku !'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Toko Buku Sederhana',
          style: TextStyle(fontSize: 17.5),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Tambah Buku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.orange[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      _showLogoutConfirmationDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda ingin keluar?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    setState(() {
      widget.isLoggedIn = false;
      widget.loggedInUsername = null;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));
  }
}
