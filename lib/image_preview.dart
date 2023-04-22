import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './global_state.dart';
import 'dart:io';

class ImagePreview extends StatelessWidget {
  final XFile picture;

  const ImagePreview(this.picture, {super.key});

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var imageModel = Provider.of<ImageModel>(context);

    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            File(picture.path),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.7,
          ),
          const SizedBox(height: 25),
          Text(
            picture.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => goBack(context),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple)),
                child: const Text("Retake"),
              ),
              ElevatedButton(
                onPressed: () {
                  imageModel.addImage(picture);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple)),
                child: const Text("Confirm"),
              )
            ],
          )
        ],
      ),
    );
  }
}
