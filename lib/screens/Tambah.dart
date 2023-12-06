import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController numberOfPagesController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController publishDateController = TextEditingController();

  String selectedCategory = 'Pendidikan'; // Default category

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBook() async {
    try {
      // Menambahkan buku ke koleksi Firebase Firestore dengan ID unik yang dibuat secara otomatis
      await _firestore.collection(selectedCategory).add({
        'title': titleController.text,
        'author': authorController.text,
        'description': descriptionController.text,
        'numberOfPages': int.tryParse(numberOfPagesController.text) ?? 0,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'publishDate': publishDateController.text,
        'image': 'url_to_image', // Ganti dengan URL gambar jika ada
      });

      // Clear text fields after adding book
      titleController.clear();
      authorController.clear();
      descriptionController.clear();
      numberOfPagesController.clear();
      priceController.clear();
      publishDateController.clear();

      // Menampilkan pesan sukses atau melakukan navigasi ke layar lain
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Buku berhasil ditambahkan'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Menangani kesalahan
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan, coba lagi nanti'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: [
                  'Pendidikan',
                  'Novel',
                  'Anak-Anak',
                  'Biografi',
                  'Bimbingan Belajar',
                  'Bahasa Asing',
                  'Komik',
                ].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextFormField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Penulis'),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              TextFormField(
                controller: numberOfPagesController,
                decoration: InputDecoration(labelText: 'Jumlah Halaman'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: publishDateController,
                decoration: InputDecoration(labelText: 'Tanggal Terbit'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addBook,
                child: Text('Tambah Buku'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}