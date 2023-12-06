import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tokobukusederhana/screens/Home.dart';
import 'package:tokobukusederhana/screens/LandingPage.dart';
import 'package:tokobukusederhana/screens/RegisterPage.dart';
import 'package:tokobukusederhana/screens/UserListPage.dart';
import 'package:tokobukusederhana/services/firebase_auth_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorText = '';

  void _handleLoginSuccess(BuildContext context, String email) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LandingPage(
        isLoggedIn: true,
        loggedInEmail: email,
      ),
    ));
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = 'Semua bidang harus diisi';
      });
    } else {
      User? user = await _authService.loginWithEmailAndPassword(email, password, context);

      if (user != null) {
        _handleLoginSuccess(context, email);
      } else {
        setState(() {
          _errorText = 'Email atau password salah';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/login.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Selamat Datang!',
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
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
                },
                child: Text('Buat Akun Baru'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserListPage()));
                },
                child: Text('Lihat Daftar Pengguna'),
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
    _passwordController.dispose();
    super.dispose();
  }
}
