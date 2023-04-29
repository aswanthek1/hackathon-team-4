import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import "./my_camera.dart";
import './global_state.dart';
import 'package:image_picker/image_picker.dart';
import "./content.dart";

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Success"),
        content: const Text("Images uploaded successfully"),
        actions: [
          CupertinoDialogAction(
              child: const Text("OKAY"),
              onPressed: () => {Navigator.of(context).pop()}),
        ],
      ),
    );
  }

  void uploadImages(
    BuildContext context,
    List<XFile> images,
    Function clearImages,
    Function toggleUploading,
  ) async {
    if (images.isEmpty) return;
    toggleUploading();
    try {
      final url = Uri.parse("https://hackathon-flutter.onrender.com/images");
      final request = http.MultipartRequest('POST', url);
      for (final image in images) {
        final multipartFile = http.MultipartFile.fromBytes(
            'files', await image.readAsBytes(),
            filename: image.name);
        request.files.add(multipartFile);
      }
      final response = await request.send();

      if (response.statusCode == 200) {
        clearImages();
        _showAlertDialog(context);
        print('File uploaded successfully');
      } else {
        print('Error uploading file: ${response.reasonPhrase}');
      }
      toggleUploading();
    } catch (e) {
      print("Error: ${e}");
      toggleUploading();
    }
  }

  void showConfirmDialog(
      BuildContext context, images, resetImages, toggleUploading) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Upload Images to AWS?",
        ),
        content: const Text(
          "Are you sure you want to upload all images picked from gallery and camera to uploaded to AWS?",
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Okay"),
            onPressed: () {
              Navigator.of(context).pop();
              uploadImages(context, images, resetImages, toggleUploading);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var imageModel = Provider.of<ImageModel>(context);
    final ImagePicker imgpicker = ImagePicker();

    openImages() async {
      try {
        var pickedfiles = await imgpicker.pickMultiImage();
        if (pickedfiles != null) {
          for (var i = 0; i < pickedfiles.length; i++) {
            imageModel.addImage(pickedfiles[i]);
          }
        } else {
          print("no image selected");
        }
      } catch (e) {
        print("error while picking file. $e");
      }
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("FotoThat"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: Colors.black,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upload Images'),
              Tab(text: 'Cloud Images'),
            ],
          ),
        ),
        body: TabBarView(children: [
          SizedBox(
            width: double.infinity,
            child: imageModel.images.isEmpty
                ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "No Images Captured",
                          style: TextStyle(fontSize: 23),
                        ),
                      ],
                    ),
                  )
                : GridView.count(
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
                            child: Stack(children: [
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
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.clear,
                                          color: Colors.white),
                                    ),
                                  ))
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          const Content()
        ]),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(left: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "upload",
                onPressed: () {
                  if (imageModel.images.isEmpty) return;
                  showConfirmDialog(
                    context,
                    imageModel.images,
                    imageModel.resetImages,
                    imageModel.toggleUploading,
                  );
                },
                backgroundColor: Colors.black,
                child: imageModel.isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.cloud, color: Colors.white),
              ),
              FloatingActionButton(
                heroTag: "camera",
                onPressed: () async {
                  await availableCameras().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MyCamera(cameras: value, context: context),
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.camera, color: Colors.white),
              ),
              FloatingActionButton(
                heroTag: "picker",
                onPressed: openImages,
                backgroundColor: Colors.black,
                child: const Icon(Icons.image, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
