part of ttf_parser;

class TtfParser {
  TtfFont parse(List<int> data) {
    var reader = ByteArrayStreamReader(data);
    var font = TtfFont();
    font.directory.parseData(reader);

    // Parse the head table
    var headEntry = font.directory.getTableEntry("head");
    reader.seek(headEntry?.offset);
    font.head.parseData(reader);

    // Parse the name table
    var nameEntry = font.directory.getTableEntry("name");
    reader.seek(nameEntry?.offset);
    font.name.parseData(reader);
    
    // Parse the profile table
    var maxpEntry = font.directory.getTableEntry("maxp");
    reader.seek(maxpEntry?.offset);
    font.maxp.parseData(reader);

    // Parse char map table
    var cmapEntry = font.directory.getTableEntry("cmap");
    reader.seek(cmapEntry?.offset);
    font.cmap.parseData(reader);
    
    // Parse the horizontal header table
    var hheaEntry = font.directory.getTableEntry("hhea");
    reader.seek(hheaEntry?.offset);
    font.hhea.parseData(reader);
    
    // Parse the horizontal metrics table
    var hmtxEntry = font.directory.getTableEntry("hmtx");
    reader.seek(hmtxEntry?.offset);
    font.hmtx.parseData(reader);
    
    // Parse the glyph locations table
    var locaEntry = font.directory.getTableEntry("loca");
    reader.seek(locaEntry?.offset);
    font.loca.parseData(reader);
    
    // Parse the glyph data table
    var glyfEntry = font.directory.getTableEntry("glyf");
    reader.seek(glyfEntry?.offset);
    font.glyf.parseData(reader);

    // Parse the postScript data table
    var postEntry = font.directory.getTableEntry("post");
    reader.seek(postEntry?.offset);
    font.post.parseData(reader);

    // Parse the kerning table
    if (font.directory.containsTable("kern")) {
      var kernEntry = font.directory.getTableEntry("kern");
      reader.seek(kernEntry?.offset);
      font.kern.parseData(reader);
    }

    return font;
  }
}
