class ImageStorage {
  List<String> _base64Images = [];
  static final ImageStorage _singleton = ImageStorage._internal();

  factory ImageStorage() {
    return _singleton;
  }

  ImageStorage._internal();

  void addBase64Image(String base64Image) {
    _base64Images.add(base64Image);
  }

  List<String> getBase64Images() {
    return _base64Images;
  }
}
