import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class ImageModel extends ChangeNotifier {
  final List<XFile> _images = [];
  late List<XFile> _galleryImages = [];
  bool isUploading = false;

  List<XFile> get images => _images;
  List<XFile> get galleryImages => _galleryImages;

  void resetImages() {
    _images.clear();
    notifyListeners();
  }

  void addImage(XFile image) {
    print("$image firest");
    _images.add(image);
    notifyListeners();
  }

  void removeImage(XFile image) {
    _images.remove(image);
    notifyListeners();
  }
  void addGalleryImage(XFile galleryImage) {
    _galleryImages.add(galleryImage);
    notifyListeners();
  }

  void toggleUploading() {
    isUploading = !isUploading;
    notifyListeners();
  }
}
