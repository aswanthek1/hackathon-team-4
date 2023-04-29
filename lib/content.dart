import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:http/http.dart' as http;

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  bool _isLoading = true;
  final List _images = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('https://hackathon-flutter.onrender.com/images');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        _images.addAll(jsonResponse['images']);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3,
                )
              ],
            ),
          )
        : _images.isEmpty
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "No Images in Cloud",
                      style: TextStyle(fontSize: 23),
                    ),
                  ],
                ),
              )
            : GridView.count(
                primary: false,
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 120,
                  right: 20,
                  left: 20,
                ),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  ..._images.map(
                    (image) => Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      child: Align(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return Stack(
                                    children: [
                                      PhotoView(
                                        minScale:
                                            PhotoViewComputedScale.contained,
                                        imageProvider:
                                            NetworkImage(image['url']),
                                      ),
                                      Positioned(
                                        top: 70,
                                        left: 40,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          width: 35,
                                          height: 35,
                                          child: Center(
                                            child: GestureDetector(
                                              child: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.black),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                image["url"],
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.height * 1,
                                width: 120,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? (loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!)
                                              : null,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }
}
