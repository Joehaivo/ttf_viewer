part of ttf_parser;

class TtfTableGlyf implements TtfTable {
  TtfFont font;
  TtfTableGlyf(this.font);
  
  // Glyph index to info mapping
  var glyphInfoMap = <int, GlyphInfo>{};
  
  @override
  void parseData(StreamReader reader) {
    var offsets = font.loca.glyphOffsets;
    var baseOffset = reader.currentPosition;
    
    int glyphIndex = 0;
    for (var offset in offsets) {
      reader.seek(baseOffset + offset);
      var glyphInfo = GlyphInfo();
      glyphInfo.index = glyphIndex;
      glyphInfo.numberOfContours = reader.readSignedShort();
      glyphInfo.xMin = reader.readSignedShort();
      glyphInfo.yMin = reader.readSignedShort();
      glyphInfo.xMax = reader.readSignedShort();
      glyphInfo.yMax = reader.readSignedShort();
      glyphInfoMap[glyphIndex] = glyphInfo;
      glyphIndex++;
      
//      print ("$glyphIndex ${glyphInfo.numberOfContours} ${glyphInfo.xMin} ${glyphInfo.yMin} ${glyphInfo.xMax} ${glyphInfo.yMax} ");
    }
  }
}


class GlyphInfo {
  late int index;
  late int numberOfContours;
  late int xMin;
  late int yMin;
  late int xMax;
  late int yMax;
}