import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<QuerySnapshot> _userList;

  @override
  void initState() {
    super.initState();
    _userList = _loadUserList();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _loadUserList() async {
  return FirebaseFirestore.instance.collection('UserList').get();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pengguna'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _userList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada data pengguna.'));
          } else {
            final userList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final userData = userList[index].data() as Map<String, dynamic>;
                final username = userData['username'];
                final email = userData['email'];

                return ListTile(
                  title: Text('Username: $username'),
                  subtitle: Text('Email: $email'),
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Hapus Pengguna'),
                              content: Text('Apakah Anda yakin ingin menghapus pengguna ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Menghapus data dari Firestore berdasarkan documentID
                                    await FirebaseFirestore.instance
                                        .collection('UserList')
                                        .doc(userList[index].id) // Menggunakan documentID dari snapshot
                                        .delete();

                                    // Refresh halaman setelah penghapusan
                                    setState(() {
                                      _userList = _loadUserList();
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: Text('Hapus'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
