part of ttf_parser;

class ParseException {
  String message;
  ParseException(this.message);
  
  String toString() {
    return message;
  }
}

class TtfParseException extends ParseException {
  TtfParseException(String message) : super(message) { }
}


class EOFException extends ParseException {
  EOFException(String message) : super(message) { }
}

