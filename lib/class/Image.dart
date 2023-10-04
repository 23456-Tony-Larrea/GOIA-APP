class ImageStorage {
  List<Map<String, dynamic>> _base64Images = [];
  static final ImageStorage _singleton = ImageStorage._internal();

  factory ImageStorage() {
    return _singleton;
  }

  ImageStorage._internal();

  void addBase64Image(String base64Image) {
    _base64Images.add({'f': base64Image});
  }

  List<Map<String, dynamic>> getBase64Images() {
    return _base64Images;
  }
}