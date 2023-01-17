part of ttf_parser;

class TtfTableName implements TtfTable {
  int? format;
  int count = 0;
  int stringOffset = 0;

  String? copyright;
  String? fontFamily;
  String? subFamily;
  String? subFamilyID;
  String? fontName;
  String? nameTableVersion;
  String? fontNamePostScript;
  String? trademarkNotice;
  String? manufacturer;
  
  
  void parseData(StreamReader reader) {
    int basePosition = reader.currentPosition;
    format = reader.readUnsignedShort();
    count = reader.readUnsignedShort();
    stringOffset = reader.readUnsignedShort();
    for (var i = 0; i < count; i++) {
      // Read the row entry
      int platformID = reader.readUnsignedShort();
      int platformSpecificID = reader.readUnsignedShort();
      int languageID = reader.readUnsignedShort();
      int nameID = reader.readUnsignedShort();
      int length = reader.readUnsignedShort();
      int offset = reader.readUnsignedShort();
      
      if (platformID == 1) {
        int currentPosition = reader.currentPosition;
        reader.seek(basePosition + stringOffset + offset);
        _registerString(nameID, reader.readStringUtf8(length));
        reader.seek(currentPosition);
      }
    }
  }
  
  void _registerString(int nameID, String value) {
    if (value.isEmpty) return;
    switch(nameID) {
      case 0: copyright = value; break;
      case 1: fontFamily = value; break;
      case 2: subFamily = value; break;
      case 3:  subFamilyID = value; break;
      case 4:  fontName = value; break;
      case 5:  nameTableVersion = value; break;
      case 6:  fontNamePostScript = value; break;
      case 7:  trademarkNotice = value; break;
      case 8:  manufacturer = value; break;
    }
  }
}
