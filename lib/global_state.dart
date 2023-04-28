import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ImageModel extends ChangeNotifier {
  final List<XFile> _images = [];

  List<XFile> get images => _images;

  void addImage(XFile image) {
    _images.add(image);
    notifyListeners();
  }
  void removeImage(XFile image) {
    _images.remove(image);
    notifyListeners();
  }
}
