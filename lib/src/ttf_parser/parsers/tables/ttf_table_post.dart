part of ttf_parser;

class TtfTablePost extends TtfTable {
  late num formatType;
  late num italicAngle;
  late int underlinePosition;
  late int underlineThickness;
  late int isFixedPitch;
  late int minMemType42;
  late int maxMemType42;
  late int minMemType1;
  late int maxMemType1;
  late List<String> glyphNames = [];

  TtfFont font;
  TtfTablePost(this.font);

  @override
  void parseData(StreamReader reader) {
    formatType = reader.read32Fixed();
    italicAngle = reader.read32Fixed();
    underlinePosition = reader.readSignedShort();
    underlineThickness = reader.readSignedShort();
    isFixedPitch = reader.readUnsignedInt();
    minMemType42 = reader.readUnsignedInt();
    maxMemType42 = reader.readUnsignedInt();
    minMemType1 = reader.readUnsignedInt();
    maxMemType1 = reader.readUnsignedInt();

    if (formatType == 1.0) {
      glyphNames = WGL4Names.MAC_GLYPH_NAMES.toList();
    } else if (formatType == 2.0) {
      int numGlyphs = reader.readUnsignedShort();
      List<int> glyphNameIndex = List.filled(numGlyphs, 0);
      glyphNames = List.filled(numGlyphs, '');
      int maxIndex = -0x80000000;
      for (int i = 0; i < numGlyphs; i++) {
        int index = reader.readUnsignedShort();
        glyphNameIndex[i] = index;
        // PDFBOX-808: Index numbers between 32768 and 65535 are
        // reserved for future use, so we should just ignore them
        if (index <= 32767) {
          maxIndex = math.max(maxIndex, index);
        }
      }
      List<String>? nameArray;
      if (maxIndex >= WGL4Names.NUMBER_OF_MAC_GLYPHS) {
        nameArray = List.filled(maxIndex - WGL4Names.NUMBER_OF_MAC_GLYPHS + 1, '');
        for (int i = 0; i < nameArray.length; i++) {
          int numberOfChars = reader.read();
          try {
            nameArray[i] = reader.readString(numberOfChars);
          } catch (ex) {
            // PDFBOX-4851: EOF
            log("Error reading names in PostScript table at entry $i of ${nameArray.length}, setting remaining entries to .notdef");
            for (int j = i; j < nameArray.length; ++j) {
              nameArray[j] = ".notdef";
            }
            break;
          }
        }
      }
      for (int i = 0; i < numGlyphs; i++) {
        int index = glyphNameIndex[i];
        if (index >= 0 && index < WGL4Names.NUMBER_OF_MAC_GLYPHS) {
          glyphNames[i] = WGL4Names.MAC_GLYPH_NAMES[index];
        } else if (index >= WGL4Names.NUMBER_OF_MAC_GLYPHS && index <= 32767) {
          glyphNames[i] = nameArray![index - WGL4Names.NUMBER_OF_MAC_GLYPHS];
        } else {
          // PDFBOX-808: Index numbers between 32768 and 65535 are
          // reserved for future use, so we should just ignore them
          glyphNames[i] = ".undefined";
        }
      }
    } else if (formatType == 2.5) {
      List<int> glyphNameIndex = List.filled(font.numGlyphs, 0);
      for (int i = 0; i < glyphNameIndex.length; i++) {
        int offset = reader.readSignedByte();
        glyphNameIndex[i] = i + 1 + offset;
      }
      glyphNames = List.filled(glyphNameIndex.length, '');
      for (int i = 0; i < glyphNames.length; i++) {
        int index = glyphNameIndex[i];
        if (index >= 0 && index < WGL4Names.NUMBER_OF_MAC_GLYPHS) {
          String name = WGL4Names.MAC_GLYPH_NAMES[index];
          glyphNames[i] = name;
        } else {
          log("incorrect glyph name index $index, valid numbers 0..${WGL4Names.NUMBER_OF_MAC_GLYPHS}");
        }
      }
    } else if (formatType == 3.0) {
      // no postscript information is provided.
      log("No PostScript name information is provided for the font ${font.name.fontName}");
    }
  }

  Map<int, String> getGlyphNameMap() {
    return glyphNames.asMap();
  }
}

/// Windows Glyph List 4 (WGL4) names for Mac glyphs.
class WGL4Names {
  /// The number of standard mac glyph names.
  static const int NUMBER_OF_MAC_GLYPHS = 258;

  /// The 258 standard mac glyph names a used in 'post' format 1 and 2.
  static final List<String> MAC_GLYPH_NAMES = [
    ".notdef",
    ".null",
    "nonmarkingreturn",
    "space",
    "exclam",
    "quotedbl",
    "numbersign",
    "dollar",
    "percent",
    "ampersand",
    "quotesingle",
    "parenleft",
    "parenright",
    "asterisk",
    "plus",
    "comma",
    "hyphen",
    "period",
    "slash",
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "colon",
    "semicolon",
    "less",
    "equal",
    "greater",
    "question",
    "at",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "bracketleft",
    "backslash",
    "bracketright",
    "asciicircum",
    "underscore",
    "grave",
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "braceleft",
    "bar",
    "braceright",
    "asciitilde",
    "Adieresis",
    "Aring",
    "Ccedilla",
    "Eacute",
    "Ntilde",
    "Odieresis",
    "Udieresis",
    "aacute",
    "agrave",
    "acircumflex",
    "adieresis",
    "atilde",
    "aring",
    "ccedilla",
    "eacute",
    "egrave",
    "ecircumflex",
    "edieresis",
    "iacute",
    "igrave",
    "icircumflex",
    "idieresis",
    "ntilde",
    "oacute",
    "ograve",
    "ocircumflex",
    "odieresis",
    "otilde",
    "uacute",
    "ugrave",
    "ucircumflex",
    "udieresis",
    "dagger",
    "degree",
    "cent",
    "sterling",
    "section",
    "bullet",
    "paragraph",
    "germandbls",
    "registered",
    "copyright",
    "trademark",
    "acute",
    "dieresis",
    "notequal",
    "AE",
    "Oslash",
    "infinity",
    "plusminus",
    "lessequal",
    "greaterequal",
    "yen",
    "mu",
    "partialdiff",
    "summation",
    "product",
    "pi",
    "integral",
    "ordfeminine",
    "ordmasculine",
    "Omega",
    "ae",
    "oslash",
    "questiondown",
    "exclamdown",
    "logicalnot",
    "radical",
    "florin",
    "approxequal",
    "Delta",
    "guillemotleft",
    "guillemotright",
    "ellipsis",
    "nonbreakingspace",
    "Agrave",
    "Atilde",
    "Otilde",
    "OE",
    "oe",
    "endash",
    "emdash",
    "quotedblleft",
    "quotedblright",
    "quoteleft",
    "quoteright",
    "divide",
    "lozenge",
    "ydieresis",
    "Ydieresis",
    "fraction",
    "currency",
    "guilsinglleft",
    "guilsinglright",
    "fi",
    "fl",
    "daggerdbl",
    "periodcentered",
    "quotesinglbase",
    "quotedblbase",
    "perthousand",
    "Acircumflex",
    "Ecircumflex",
    "Aacute",
    "Edieresis",
    "Egrave",
    "Iacute",
    "Icircumflex",
    "Idieresis",
    "Igrave",
    "Oacute",
    "Ocircumflex",
    "apple",
    "Ograve",
    "Uacute",
    "Ucircumflex",
    "Ugrave",
    "dotlessi",
    "circumflex",
    "tilde",
    "macron",
    "breve",
    "dotaccent",
    "ring",
    "cedilla",
    "hungarumlaut",
    "ogonek",
    "caron",
    "Lslash",
    "lslash",
    "Scaron",
    "scaron",
    "Zcaron",
    "zcaron",
    "brokenbar",
    "Eth",
    "eth",
    "Yacute",
    "yacute",
    "Thorn",
    "thorn",
    "minus",
    "multiply",
    "onesuperior",
    "twosuperior",
    "threesuperior",
    "onehalf",
    "onequarter",
    "threequarters",
    "franc",
    "Gbreve",
    "gbreve",
    "Idotaccent",
    "Scedilla",
    "scedilla",
    "Cacute",
    "cacute",
    "Ccaron",
    "ccaron",
    "dcroat"
  ];

  /// The indices of the standard mac glyph names.
  static final Map<String, int> MAC_GLYPH_NAMES_INDICES =
      MAC_GLYPH_NAMES.asMap().map((key, value) => MapEntry(value, key));
}
