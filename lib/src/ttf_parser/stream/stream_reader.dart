part of ttf_parser;

abstract class StreamReader {
  
  // Reads a 16.16 fixed value. The first 16 bits represent the decimal
  // and the last 16 bits represent the fraction
  num read32Fixed() {
    num value = readSignedShort();
    value += (readUnsignedShort() / 65536);
    return value;
  }
  
  String readString(int length) {
    var buffer = new StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.writeCharCode(read());
    }
    return buffer.toString();
  }

  String readStringUtf8(int length) {
    List<int> data = <int>[];
    data = readBytes(length);
    return new Utf8Codec().decode(data);
  }

  // Read a signed byte from the stream
  int readSignedByte() {
    int value = read();
    return value < 127 ? value : value - 256;
    
  }
  
  int readUnsignedInt() {
    int byte1 = read();
    int byte2 = read();
    int byte3 = read();
    int byte4 = read();
    if (byte4 < 0) {
      throw new EOFException("End of stream reached");
    }
    
    return (byte1 << 24) + (byte2 << 16) + (byte3 << 8) + (byte4);
  }
  
  // Read a long value from the stream
  int readSignedInt() {
    int value = readUnsignedInt();
    if ((value & 0x80000000) > 0) {
      // This is a negative number.  Invert the bits and add 1
      value = (~value & 0xFFFFFFFF) + 1;
      
      // Add a negative sign
      value = -value;
    }
    return value;
  }
  
  // Read an unsigned short
  int readUnsignedShort() {
    int byte1 = read();
    int byte2 = read();
    if (byte2 < 0) {
      throw new EOFException("End of stream reached");
    }
    
    return (byte1 << 8) + (byte2);
  }
  
  // Read a short from the stream
  int readSignedShort() {
    int value = readUnsignedShort();
    if ((value & 0x8000) > 0) {
      // This is a negative number.  Invert the bits and add 1 and negate it
      value = (~value & 0xFFFF) + 1;
      value = -value;
    }
    return value;
  }
  
  // Read the data
  int readDate() {
    int epoch = readUnsignedInt();
    epoch = (epoch << 32) + readUnsignedInt();
    return epoch;
  }

  
  // Read an unsigned byte
  int read();
  
  // Read an unsigned byte
  List<int> readBytes(int count);
  
  // Close the stream
  void close();

  // Seek to the specified position in the stream
  void seek(int? position);
  
  // Get the current seek position of the stream
  int get currentPosition;
  
  List<int> readOffsetFromArray(int offset, int length);
  
}
