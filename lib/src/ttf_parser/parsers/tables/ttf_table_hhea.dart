part of ttf_parser;

/** 
 * The Horizontal header table 
 * Specs: https://developer.apple.com/fonts/TTRefMan/RM06/Chap6hhea.html
 * */
class TtfTableHhea implements TtfTable {
  late num version;
  late int ascent;
  late int descent;
  late int lineGap;
  late int advanceWidthMax;
  late int minLeftSideBearing;
  late int minRightSideBearing;
  late int xMaxExtent;
  late int caretSlopeRise;
  late int caretSlopeRun;
  late int caretOffset;
  late int reserved1;
  late int reserved2;
  late int reserved3;
  late int reserved4;
  late int metricDataFormat;
  late int numOfLongHorMetrics;
  
  void parseData(StreamReader reader) {
    version = reader.read32Fixed();
    ascent = reader.readSignedShort();
    descent = reader.readSignedShort();
    lineGap = reader.readSignedShort();
    advanceWidthMax = reader.readUnsignedShort();
    minLeftSideBearing = reader.readSignedShort();
    minRightSideBearing = reader.readSignedShort();
    xMaxExtent = reader.readSignedShort();
    caretSlopeRise = reader.readSignedShort();
    caretSlopeRun = reader.readSignedShort();
    caretOffset = reader.readSignedShort();
    reserved1 = reader.readSignedShort();
    reserved2 = reader.readSignedShort();
    reserved3 = reader.readSignedShort();
    reserved4 = reader.readSignedShort();
    metricDataFormat = reader.readSignedShort();
    numOfLongHorMetrics = reader.readUnsignedShort();
  }
}
