import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import "./my_camera.dart";
import './global_state.dart';
import 'package:image_picker/image_picker.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});
  @override
  Widget build(BuildContext context) {
    var imageModel = Provider.of<ImageModel>(context);
    final ImagePicker imgpicker = ImagePicker();

    openImages() async {
      try {
        var pickedfiles = await imgpicker.pickMultiImage();
      if(pickedfiles != null) {
        for(var i=0; i<pickedfiles.length; i++){
          imageModel.addGalleryImage(pickedfiles[i]);
        }
      }
      else {
        print("no image selected");
      }
      } catch (e) {
        print("error while picking file. $e");
      }

    }


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
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: Align(
                    child: Stack(
                      children:[
                        Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 1,
                          width: 120,
                        ),
                        Positioned(
                          right: -1,
                          top: -1,
                          child: GestureDetector(
                          onTap: () {
                            imageModel.removeImage(image);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle 
                            ),
                            child: const Icon(Icons.clear,color: Colors.white),
                          ),
                        ))
                      ]
                    ),
                  ),
                ),
              )
            ],
          )),
      floatingActionButton: 
      Padding(padding: EdgeInsets.only(left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //for gallery
          FloatingActionButton(
        onPressed: ()  {
          openImages();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.image, color: Colors.white),
      ),
      Expanded(child: Container()),
      //for camera
      FloatingActionButton(
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
        ],
      ),
      )
    );
  }
}
