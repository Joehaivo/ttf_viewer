part of ttf_parser;

/** 
 * The Character Code to Glyph Indices mapping table 
 * Specs: https://developer.apple.com/fonts/TTRefMan/RM06/Chap6cmap.html
 * */
class TtfTableCmap implements TtfTable {
  // Character Code to Glyph Index mapping
  var codePointToGlyphIndexMap = <int, int>{};
  var glyphIndexToCodePointMap = <int, int>{};
  late int languageID;
  
  void parseData(StreamReader reader) {
    int baseOffset = reader.currentPosition;
    
    // Read the cmap table header
    int version = reader.readUnsignedShort();
    // Make sure the version is set to 0
    if (version != 0) {
      throw ParseException("Invalid CMAP table version number");
    }
    
    int numSubTables = reader.readUnsignedShort();
    
//    print ("Num encoding subtables: $numSubTables");
    // Read the cmap sub-table entries
    var subTablesEntries = <_CMapSubTableEntry>[];
    for (var i = 0; i < numSubTables; i++) {
      var entry = _CMapSubTableEntry();
      entry.platformID = reader.readUnsignedShort();
      entry.platformSpecificID = reader.readUnsignedShort();
      entry.offset = reader.readUnsignedInt();
      subTablesEntries.add(entry);
//      print ("Entry platform id : ${entry.platformID} ${entry.platformSpecificID} ${entry.offset} ");
    }
    
    // Iterate through all the sub table entries and select a sub table with format 0 (ASCII)
    // TODO: Implement support for other formats for UTF8/16/32
    var validSubTableFound = false;
    for (_CMapSubTableEntry subTableEntry in subTablesEntries) {
      if (subTableEntry.platformID != 3) continue;
      
      // Seek to the offset of this table
      reader.seek(baseOffset + subTableEntry.offset);
      int format = reader.readUnsignedShort();
//      print ("Processing sub table with format: $format");
      if (format == 0) {
        parseSubtableFormat0(reader);
        validSubTableFound = true;
      }
      else if (format == 4) {
        parseSubtableFormat4(reader);
        validSubTableFound = true;
      }
      else if (format == 6) {
        parseSubtableFormat6(reader);
        validSubTableFound = true;
      }
    }
    
    if (!validSubTableFound) {
      throw ParseException("Cannot find a valid cmap subtable.  Only ASCII fonts are supported for now");
    }
  }
  
  void parseSubtableFormat4(StreamReader reader) { 
    int length = reader.readUnsignedShort();
    int language = reader.readUnsignedShort();
    int segCountX2 = reader.readUnsignedShort();
    int searchRange = reader.readUnsignedShort();
    int entrySelector = reader.readUnsignedShort();
    int rangeShift = reader.readUnsignedShort();

    int segCount = segCountX2 ~/ 2;

    // Read the end codes
    var endCodes = <int>[];
    for (var i = 0; i < segCount; i++) {
      endCodes.add(reader.readUnsignedShort());
    }

    // Read the reserved pad and make sure it is 0
    int reservedPad = reader.readUnsignedShort();
    if (reservedPad != 0) {
      throw ParseException("Failed to parse cmap subtable (format 4)");
    }
    
    // Read the start codes
    var startCodes = <int>[];
    for (var i = 0; i < segCount; i++) {
      startCodes.add(reader.readUnsignedShort());
    }
    
    // Read the id delta list
    var idDeltas = <int>[];
    for (var i = 0; i < segCount; i++) {
      idDeltas.add(reader.readUnsignedShort());
    }
    
    // Read the id range offset table
    int idRangeOffsetBasePos = reader.currentPosition;
    var idRangeOffsets = <int>[];
    var idRangeOffsetsAddress = <int>[];
    for (var i = 0; i < segCount; i++) {
      idRangeOffsetsAddress.add(reader.currentPosition);
      idRangeOffsets.add(reader.readUnsignedShort());
    }
    
    for (var s = 0; s < segCount - 1; s++) {
      var startCode = startCodes[s];
      var endCode = endCodes[s];
      var idDelta = idDeltas[s];
      var idRangeOffset = idRangeOffsets[s];
      var idRangeOffsetAddress = idRangeOffsetsAddress[s];
//      print ("Segment $s: $startCode - $endCode");
      
      for (var c = startCode; c <= endCode; c++) {
        var glyphIndex;
        if (idRangeOffset == 0) {
          glyphIndex = (idDelta + c) % 65536;
        } else {
          var glyphIndexAddress = idRangeOffset + 2 * (c - startCode) + idRangeOffsetAddress;
          reader.seek(glyphIndexAddress);
          glyphIndex = reader.readUnsignedShort();
        }

        codePointToGlyphIndexMap[c] = glyphIndex;
        glyphIndexToCodePointMap[glyphIndex] = c;
//        print ("Char to Glyph mapping: $c <=> $glyphIndex");
      }
    }
  }

  void parseSubtableFormat6(StreamReader reader) {
    int length = reader.readUnsignedShort();
    int language = reader.readUnsignedShort();
    int firstCode = reader.readUnsignedShort(); 
    int entryCount = reader.readUnsignedShort(); 
    for (var i = 0; i < entryCount; i++) {
      int charCode = firstCode + i;
      int glyphIndex = reader.readUnsignedShort();
      codePointToGlyphIndexMap[charCode] = glyphIndex;
      glyphIndexToCodePointMap[glyphIndex] = charCode;
//      print ("Char to Glyph mapping: $charCode <=> $glyphIndex");
    }
  }
  
  void parseSubtableFormat0(StreamReader reader) {
    // Make sure the length is 262 (fixed)
    int length = reader.readUnsignedShort();
    if (length != 262) {
      throw ParseException("Invalid cmap subtable format");
    }
    
    languageID = reader.readUnsignedShort();
    for (var i = 0; i < 256; i++) {
      int charCode = i;
      int glyphIndex = reader.read();
      if (glyphIndex > 0) {
        codePointToGlyphIndexMap[charCode] = glyphIndex;
        glyphIndexToCodePointMap[glyphIndex] = charCode;
      }
    }
  }
}

class _CMapSubTableEntry {
  late int platformID;
  late int platformSpecificID;
  late int offset;
}
 