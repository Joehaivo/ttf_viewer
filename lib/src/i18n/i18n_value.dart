import 'package:get/get_navigation/src/root/internacionalization.dart';

class I18n {
  static const String parseFileError = "parseFileError";
  static const String ok = "ok";
  static const String fabTip = "fabTip";
  static const String dropTtfHere = "dropTtfHere";
  static const String fontInfo = "fontInfo";
  static const String fontName = "fontName";
  static const String fontFamily = "fontFamily";
  static const String fontFileName = "fontFileName";
  static const String fontFilePath = "fontFilePath";
  static const String fontCopyright = "fontCopyright";
  static const String fontSubFamily = "fontSubFamily";
  static const String fontSubFamilyID = "fontSubFamilyID";
  static const String fontNumGlyph = "fontNumGlyph";
  static const String glyphsJson = "developJson";
  static const String tapToCopyJsonCode = "tapToCopyJsonCode";
  static const String textCopied = "textCopied";

  static const String fontSetting = "fontSetting";
  static const String iconColor = "iconColor";
  static const String iconSize = "iconSize";
}

class I18nValue extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          I18n.parseFileError: "解析文件失败，请选择TrueType字体文件(.ttf)",
          I18n.ok: "好的",
          I18n.fabTip: "选择一个.ttf字体文件",
          I18n.dropTtfHere: "点击右下角'+'号按钮打开.ttf文件来浏览图标\n或者拖动.ttf文件到此窗口",
          I18n.fontInfo: "字体信息",
          I18n.fontName: "字体名:",
          I18n.fontFamily: "字体族:",
          I18n.fontFileName: "文件名:",
          I18n.fontFilePath: "文件路径:",
          I18n.fontCopyright: "版权声明:",
          I18n.fontSubFamily: "字体子族:",
          I18n.fontSubFamilyID: "字体子族ID:",
          I18n.fontNumGlyph: "字形总数:",
          I18n.glyphsJson: "字形代码:",
          I18n.tapToCopyJsonCode: "<点击复制代码>",
          I18n.textCopied: "文字已复制",
          I18n.fontSetting: "设置",
          I18n.iconColor: "图标颜色:",
          I18n.iconSize: "图标大小:",
        },
        'en_US': {
          I18n.parseFileError: "Parse the file failed, please choose a TrueType font file (.ttf).",
          I18n.ok: "OK",
          I18n.fabTip: "Choose .ttf file",
          I18n.dropTtfHere: "Click the '+' button in the corner to open the .ttf file to browse the icon\nOr drag the .ttf file to this window",
          I18n.fontInfo: "Font info:",
          I18n.fontName: "Font name:",
          I18n.fontFamily: "Font family:",
          I18n.fontFileName: "File name:",
          I18n.fontFilePath: "File path:",
          I18n.fontCopyright: "Copyright:",
          I18n.fontSubFamily: "SubFamily:",
          I18n.fontSubFamilyID: "SubFamily ID:",
          I18n.fontNumGlyph: "Number of glyph:",
          I18n.glyphsJson: "Glyph Code:",
          I18n.tapToCopyJsonCode: "<Click to copy code>",
          I18n.textCopied: "Text copied",
          I18n.fontSetting: "Setting",
          I18n.iconColor: "Icon color:",
          I18n.iconSize: "Icon size:",
        }
      };
}
