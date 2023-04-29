import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ImageModel extends ChangeNotifier {
  final List<XFile> _images = [];
  bool isUploading = false;

  List<XFile> get images => _images;

  void resetImages() {
    _images.clear();
    notifyListeners();
  }

  void addImage(XFile image) {
    _images.add(image);
    notifyListeners();
  }

  void removeImage(XFile image) {
    _images.remove(image);
    notifyListeners();
  }

  void toggleUploading() {
    isUploading = !isUploading;
    notifyListeners();
  }
}
