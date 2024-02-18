import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  dynamic newsItem;

  DetailScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TextButton(
          child: Text(
            '뒤로가기',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 245,
                width: double.infinity,
                child: newsItem['urlToImage'] != null
                    ? ClipRRect(
                        child: Image.network(
                          newsItem['urlToImage'],
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )
                    : ClipRRect(
                        child: Image.asset('assets/image.png'),
                        borderRadius: BorderRadius.circular(10),
                      ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32),
                child: Text(
                  newsItem['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                child: Text(
                  formatDate(newsItem['publishedAt']),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 32,),
              Text(newsItem['description']) != null
                  ? Text(newsItem['description'])
                  : Text('내용 없음'),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }
}
