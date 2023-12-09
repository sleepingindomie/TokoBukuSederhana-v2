import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tokobukusederhana/screens/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorText = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _register() async {
  final email = _emailController.text;
  final fullname = _fullnameController.text;
  final username = _usernameController.text;
  final phoneNumber = _phoneNumberController.text; 
  final password = _passwordController.text;
  

  if (email.isEmpty || fullname.isEmpty ||  username.isEmpty || password.isEmpty || phoneNumber.isEmpty) {
    setState(() {
      _errorText = 'Semua bidang harus diisi';
    });
  } else {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Registrasi berhasil
        setState(() {
          _errorText = ''; // Hapus pesan kesalahan jika ada
        });

        // Simpan data pengguna ke Firestore, termasuk phoneNumber
        await _firestore.collection('UserList').add({
          'email': email,
          'fullname': fullname,
          'username': username,
          'phoneNumber': phoneNumber, // Menyimpan phoneNumber di Firestore
          // Anda dapat menambahkan lebih banyak data pengguna jika diperlukan
        });

        // Tampilkan notifikasi "Selamat bergabung!"
        final snackBar = SnackBar(
          content: Text('Selamat bergabung!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1), // Durasi notifikasi
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Navigasi ke halaman LoginPage setelah notifikasi
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
        });
      }
    } catch (error) {
      // Gagal mendaftarkan pengguna
      setState(() {
        _errorText = 'Gagal mendaftarkan pengguna';
      });
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/register.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              Text(
                'Daftar dulu yuk!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _fullnameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              
              SizedBox(height: 10),
              Text(
                _errorText,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Daftar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Sudah punya akun?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullnameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
