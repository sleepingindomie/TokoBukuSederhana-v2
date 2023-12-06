import 'package:flutter/material.dart';

class DescPage extends StatelessWidget {
  final String bookTitle;
  final String bookDescription;
  final String bookImage;
  final String author;
  final String publishDate;
  final String numberOfPages;
  final String category;

  DescPage({
    required this.bookTitle,
    required this.bookDescription,
    required this.bookImage,
    required this.author,
    required this.publishDate,
    required this.numberOfPages,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        'Deskripsi Buku',
        style: TextStyle(fontSize: 17.5),
      ),
      backgroundColor: Colors.orange[800],
    ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                bookImage,
                height: 200,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Title: $bookTitle',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Author: $author',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Published Date: $publishDate',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Number of Pages: $numberOfPages',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Category: $category',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              bookDescription,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
