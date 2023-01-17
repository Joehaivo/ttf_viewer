part of ttf_parser;

class TtfTableLoca implements TtfTable {
  TtfFont font;
  TtfTableLoca(this.font);
  
  // Offsets for each glyph index
  var glyphOffsets = <int>[];

  void parseData(StreamReader reader) {
    // Find out the index format from the head table
    int format = font.head.indexToLocFormat;
    bool shortOffsets = (format == 0);
    final numGlyphs = font.maxp.numGlyphs;
    for (var i = 0; i < numGlyphs; i++) {
      int offset;
      if (shortOffsets) {
        offset = reader.readUnsignedShort() * 2;
      } else {
        offset = reader.readUnsignedInt();
      }
      glyphOffsets.add(offset);
      
//      print ("$i\t$offset");
    }
  }
}
