part of ttf_parser;

class TtfTableMaxp implements TtfTable {
  late num version;
  late int numGlyphs;
  late int maxPoints;
  late int maxContours;
  late int maxComponentPoints;
  late int maxComponentContours;
  late int maxZones;
  late int maxTwilightPoints;
  late int maxStorage;
  late int maxFunctionDefs;
  late int maxInstructionDefs;
  late int maxStackElements;
  late int maxSizeOfInstructions;
  late int maxComponentElements;
  late int maxComponentDepth;
  
  void parseData(StreamReader reader) {
    version = reader.read32Fixed();
    numGlyphs = reader.readUnsignedShort();
    maxPoints = reader.readUnsignedShort();
    maxContours = reader.readUnsignedShort();
    maxComponentPoints = reader.readUnsignedShort();
    maxComponentContours = reader.readUnsignedShort();
    maxZones = reader.readUnsignedShort();
    maxTwilightPoints = reader.readUnsignedShort();
    maxStorage = reader.readUnsignedShort();
    maxFunctionDefs = reader.readUnsignedShort();
    maxInstructionDefs = reader.readUnsignedShort();
    maxStackElements = reader.readUnsignedShort();
    maxSizeOfInstructions = reader.readUnsignedShort();
    maxComponentElements = reader.readUnsignedShort();
    maxComponentDepth = reader.readUnsignedShort();
  }
}
