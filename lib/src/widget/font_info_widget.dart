import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../i18n/i18n_value.dart';
import '../ttf_parser/ttf_parser.dart';

class FontInfoWidget extends StatelessWidget {
  const FontInfoWidget({
    Key? key,
    required this.font,
  }) : super(key: key);

  final TtfFont font;

  String getFontJson() {
    try {
      return jsonEncode(font.getGlyphNameToCodePointMap());
    } catch (e) {
      e.printError();
    }
    return '{}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
        decoration: const BoxDecoration(color: Color(0xfff3f3f3), borderRadius: BorderRadius.all(Radius.circular(8))),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffececec)))),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        I18n.fontInfo.tr,
                        style: const TextStyle(fontSize: 18, color: Color(0xff151515)),
                      ),
                    ),
                  ],
                ),
              ),
              /// generated multi-line widget to show font info
              ...<String, String>{
                I18n.fontName.tr: font.name.fontName ?? '-',
                I18n.fontFamily.tr: font.name.fontFamily ?? '-',
                // I18n.fontSubFamily.tr: font.name.subFamily ?? '-',
                // I18n.fontSubFamilyID.tr: font.name.subFamilyID ?? '-',
                I18n.fontCopyright.tr: font.name.copyright ?? '-',
                I18n.fontFileName.tr: font.fileName ?? '-',
                I18n.fontFilePath.tr: font.filePath ?? '-',
                I18n.fontNumGlyph.tr: font.numGlyphs.toString() ?? '-',
                I18n.glyphsJson.tr: I18n.tapToCopyJsonCode.tr,
              }
                  .map((infoName, infoValue) => MapEntry(
                      infoName,
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              infoName,
                              style: const TextStyle(fontSize: 15, color: Color(0xff151515)),
                            ),
                            Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      if (infoName == I18n.glyphsJson.tr) {
                                        Clipboard.setData(ClipboardData(text: getFontJson()));
                                      } else {
                                        Clipboard.setData(ClipboardData(text: infoValue));
                                      }
                                      Get.showSnackbar(GetSnackBar(
                                        message: I18n.textCopied.tr,
                                      ));
                                      Future.delayed(const Duration(milliseconds: 1500), () => Get.back());
                                    },
                                    child: Text(
                                      infoValue,
                                      style: const TextStyle(fontSize: 15, color: Color(0xff9b9b9b)),
                                      textAlign: TextAlign.end,
                                    ))),
                          ],
                        ),
                      )))
                  .values
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
