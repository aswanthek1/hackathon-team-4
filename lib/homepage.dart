import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import "./my_camera.dart";
import './global_state.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});
  @override
  Widget build(BuildContext context) {
    var imageModel = Provider.of<ImageModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("FotoThat"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: Colors.black,
      ),
      body: SizedBox(
          width: double.infinity,
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              ...imageModel.images.map(
                (image) => Container(
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: Align(
                    child: Stack(
                      children:[
                        Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 1,
                          width: 90,
                        ),
                        Positioned(
                          right: -1,
                          top: -1,
                          child: GestureDetector(
                          onTap: () {
                            imageModel.removeImage(image);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 228, 95, 86),
                              shape: BoxShape.circle 
                            ),
                            child: Icon(Icons.clear,color: Colors.white),
                          ),
                        ))
                      ]
                    ),
                  ),
                ),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await availableCameras().then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyCamera(cameras: value, context: context),
              ),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.camera, color: Colors.white),
      ),
    );
  }
}
