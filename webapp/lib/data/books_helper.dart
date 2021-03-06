import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../favorite_screen.dart';
import 'book.dart';

class BooksHelper {
  final String urlKey = '&key=AIzaSyCKMrZojVAr9JkSg-81u3tokk8i5ulTu94';
  final String urlQuery = 'volumes?q=';
  final String urlBase = 'https://www.googleapis.com/books/v1/';

  Future<List<dynamic>> getBooks(String query) async {
    final String url = urlBase + urlQuery + query + urlKey;

    Response result = await http.get(url);

    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      final booksMap = jsonResponse['items'];
      List<dynamic> books = booksMap.map((book) => Book.fromJson(book)).toList();

      return books;
    } else {
      return null;
    }
  }

  Future addToFavorites(Book book) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString(book.id);

    if (id != '') {
      await preferences.setString(book.id, json.encode(book.toJson()));
    }
  }

  Future removeFromFavorites(Book book, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString(book.id);

    if (id != '') {
      await preferences.remove(book.id);
      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen()));
    }
  }

  Future<List<dynamic>> getFavorites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<dynamic> books = List<dynamic>();
    Set allKeys = preferences.getKeys();

    if (allKeys.isNotEmpty) {
      for(int i = 0; i < allKeys.length; i++) {
        String key = allKeys.elementAt(i).toString();
        String value = preferences.get(key);
        dynamic json = jsonDecode(value);
        Book book = Book(json['id'], json['title'], json['authors'], json['description'], json['publisher']);
        books.add(book);
      }
    }

    return books;
  }
}
