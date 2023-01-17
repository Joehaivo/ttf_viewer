import 'dart:typed_data';

class ChooseFontResultWrapper {
  Uint8List? bytes;
  String? fileName;
  String? filePath;

  ChooseFontResultWrapper({required this.bytes, this.fileName, this.filePath});
}