part of ttf_parser;

class TtfTableKern implements TtfTable {
  late num version;
  late int nTables;
  Map<int, Map<int, int>> kernings = new Map<int, Map<int, int>>();
  late TtfFont font;
  TtfTableKern(this.font);
  
  void parseData(StreamReader reader) {
//    version = reader.read32Fixed();
    version = reader.readUnsignedShort();
    nTables = reader.readUnsignedShort();
    
    for (var i = 0; i < nTables; i++) {
      _parseSubTable(reader);
    }
  }
  
  void _parseSubTable(StreamReader reader) {
    int baseOffset = reader.currentPosition;
    int version = reader.readUnsignedShort();
    int length = reader.readUnsignedShort();
    int coverage = reader.readUnsignedShort();
    
    bool kernVertical = (coverage & 0x0008) > 0;
    bool kernCrossStream   = (coverage & 0x0004) > 0;
    bool kernVariation = (coverage & 0x0002) > 0;
    int kernFormatMask = coverage & 0xFF00;
    
    if (kernFormatMask == 0) {
      _parseFormat0(reader);
    } 
    reader.seek(baseOffset + length);
  }

  void _parseFormat0(StreamReader reader) {
    int nPairs = reader.readUnsignedShort();
    int searchRange = reader.readUnsignedShort();
    int entrySelector = reader.readUnsignedShort();
    int rangeShift = reader.readUnsignedShort();
    
    for (var i = 0; i < nPairs; i++) {
      int left = reader.readUnsignedShort();
      int right = reader.readUnsignedShort();
      int value = reader.readSignedShort();
      
      _registerKerning(left, right, value);
    }
  }

  void _registerKerning(int leftGlyphId, int rightGlyphId, int value) {
    int leftKeyCode = font.cmap.glyphIndexToCodePointMap[leftGlyphId]!;
    int rightKeyCode = font.cmap.glyphIndexToCodePointMap[rightGlyphId]!;
    if (!kernings.containsKey(leftKeyCode)) {
      kernings[leftKeyCode] = <int, int>{};
    }
    kernings[leftKeyCode]?[rightKeyCode] = value;
  }
}
