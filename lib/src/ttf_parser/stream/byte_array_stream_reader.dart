part of ttf_parser;

class ByteArrayStreamReader extends StreamReader {

  List<int> data = <int>[];
  int position = 0;
  
  ByteArrayStreamReader(this.data);
  
  // Read an unsigned byte
  @override
  int read() {
    return data[position++];
  }
  
  // Read an unsigned byte
  @override
  List<int> readBytes(int count) {
    var result = <int>[];
    result.addAll(data.getRange(position, position + count));
    position += count;
    return result;
  }

  // Close the stream
  @override
  void close() {
  }

  // Seek to the specified position in the stream
  @override
  void seek(int? position) {
    if (position == null) {
      return;
    }
    this.position = position;
  }
  
  // Get the current seek position of the stream
  @override
  int get currentPosition => position;
  
  @override
  List<int> readOffsetFromArray(int offset, int length) {
    return data.getRange(offset, length).toList();
  }
  
}
