part of ttf_parser;

class TableDirectoryEntry {
  late String name;
  late int checksum;
  late int offset;
  late int length;
}

class FontDirectory implements TtfTable {
  late int scalarType;
  late int numTables;
  late int searchRange;
  late int entrySelector;
  late int rangeShift;
  var tableEntries = new Map<String, TableDirectoryEntry>();

  void parseData(StreamReader reader) {
    scalarType = reader.readUnsignedInt();
    numTables = reader.readUnsignedShort();
    searchRange = reader.readUnsignedShort();
    entrySelector = reader.readUnsignedShort();
    rangeShift = reader.readUnsignedShort();
    // Extract the offset of each table
      for (var i = 0; i < numTables!; i++) {
            var entry = TableDirectoryEntry();
            entry.name = reader.readString(4);
            entry.checksum = reader.readUnsignedInt();
            entry.offset = reader.readUnsignedInt();
            entry.length = reader.readUnsignedInt();
            tableEntries[entry.name] = entry;
          }

  }
  
  bool containsTable(String tableName) => tableEntries.containsKey(tableName);
  
  TableDirectoryEntry? getTableEntry(String tableName) {
    if (!tableEntries.containsKey(tableName)) {
      throw ParseException("Cannot find table entry: $tableName");
    }
    return tableEntries[tableName];
  }
}
