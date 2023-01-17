part of ttf_parser;

class TtfFont {
  late FontDirectory directory;
  late TtfTableHead head;
  late TtfTableMaxp maxp;
  late TtfTableCmap cmap;
  late TtfTableHhea hhea;
  late TtfTableHmtx hmtx;
  late TtfTableLoca loca;
  late TtfTableGlyf glyf;
  late TtfTableKern kern;
  late TtfTableName name;
  late TtfTablePost post;

  // a unique font family name for develop
  late String uniqueFontFamily;
  String filePath = '';
  String fileName = '';

  TtfFont() {
    directory = FontDirectory();
    head = TtfTableHead();
    maxp = TtfTableMaxp();
    cmap = TtfTableCmap();
    hhea = TtfTableHhea();
    name = TtfTableName();
    post = TtfTablePost(this);
    hmtx = TtfTableHmtx(this);
    loca = TtfTableLoca(this);
    glyf = TtfTableGlyf(this);
    kern = TtfTableKern(this);
  }

  int get unitsPerEm => head.unitsPerEm;

  int get numGlyphs => maxp.numGlyphs;

  GlyphInfo? getGlyphInfo(String ch) {
    int charCode = ch.codeUnits[0];
    return getGlyphInfoFromCode(charCode);
  }

  GlyphInfo? getGlyphInfoFromCode(int charCode) {
    int glyphIndex = cmap.codePointToGlyphIndexMap[charCode]!;
    if (glyphIndex == null) return null;
    var glyphInfo = glyf.glyphInfoMap[glyphIndex];
    return glyphInfo;
  }

  final int pixelsPerEm = 16;

  int getPixels(int unitsInEm, num sizeInEm) {
    var normalizedPixels = (unitsInEm * pixelsPerEm) / unitsPerEm;
    return (normalizedPixels * sizeInEm).round().toInt();
  }

  GlyphBoundingBox getGlyphBoundingBox(GlyphInfo glyphInfo, num sizeInEm) {
    var bbox = GlyphBoundingBox();
    bbox.xMin = getPixels(glyphInfo.xMin, sizeInEm);
    bbox.yMin = getPixels(glyphInfo.yMin, sizeInEm);
    bbox.xMax = getPixels(glyphInfo.xMax, sizeInEm);
    bbox.yMax = getPixels(glyphInfo.yMax, sizeInEm);
    return bbox;
  }

  Map<String, String?> getGlyphNameToCodePointMap({int radix = 16}) {
    return post.glyphNames.asMap().map((key, value) => MapEntry(value, cmap.glyphIndexToCodePointMap[key]?.toRadixString(radix)));
  }
}
