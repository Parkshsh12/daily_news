import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> lstNewsInfo = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNewsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff424242),
        title: Text(
          '📰HeadLine News',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: lstNewsInfo.length,
        itemBuilder: (context, index) {
          var newsItem = lstNewsInfo[index];
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  /// 이미지
                  Container(
                    height: 170,
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

                  /// 반투명 검정 UI
                  Container(
                    height: 57,
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            newsItem['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6,),
                          Align(
                            child: Text(
                              formatDate(newsItem['publishedAt']),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            alignment: Alignment.bottomRight,
                          ),
                        ],
                      ),
                    ),
                  ),
                  /// 하얀색 뉴스 제목, 일자 텍스트
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: newsItem);
            },
          );
        },
      ),
    );
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }

  Future getNewsInfo() async {
    const apiKey = '43b11bca888a470f92a504891c5d8924';
    const apiUrl =
        'https://newsapi.org/v2/top-headlines?country=kr&apiKey=$apiKey';

    try {
      // 네트워크 통신 요청하고 with response 변수에 결과 값이 저장댐.
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          lstNewsInfo = responseData['articles'];
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print(error);
    }
  }
}
