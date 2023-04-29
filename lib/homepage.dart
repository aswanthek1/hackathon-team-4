import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import "./my_camera.dart";
import './global_state.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  void uploadImages(
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
                                color: Colors.black, shape: BoxShape.circle),
                            child: const Icon(Icons.clear, color: Colors.white),
                          ),
                        ))
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () => uploadImages(imageModel.images,
                  imageModel.resetImages, imageModel.toggleUploading),
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
                  : const Icon(Icons.upload, color: Colors.white),
            ),
            FloatingActionButton(
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
            )
          ],
        ),
      ),
    );
  }
}
