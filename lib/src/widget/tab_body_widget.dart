import 'dart:math';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../bean/font_element_vo.dart';
import 'package:get/get.dart';

import '../i18n/i18n_value.dart';
import '../ttf_parser/ttf_parser.dart';
import 'font_info_widget.dart';

/// include search bar and icons grid view
class TabBodyWidget extends StatefulWidget {
  const TabBodyWidget({
    Key? key,
    required TtfFont? font,
  })  : _font = font,
        super(key: key);

  final TtfFont? _font;

  @override
  State<TabBodyWidget> createState() => _TabBodyWidgetState();
}

class _TabBodyWidgetState extends State<TabBodyWidget> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  List<FontElementVo>? fontElements;
  var isExpanded = false.obs;
  var iconColor = Color(Colors.black.value).obs;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn);
    super.initState();
  }

  void _searchIcon(String glyphName) {
    var result = <FontElementVo>[];
    widget._font?.post.glyphNames.asMap().forEach((index, name) {
      if (name.contains(glyphName)) {
        var fontElementVo = FontElementVo()
          ..codePoint = widget._font?.cmap.glyphIndexToCodePointMap[index] ?? 0
          ..glyphName = name;
        result.add(fontElementVo);
      }
    });
    setState(() {
      fontElements = result;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              /// searchBar
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: Colors.deepPurple)),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15, right: 5),
                        child: Icon(
                          Icons.search,
                          size: 25,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: searchController,
                        onChanged: (input) {
                          _searchIcon(input);
                        },
                      ))
                    ],
                  ),
                ),
              ),
              Obx(() {
                return IconButton(
                  padding: const EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                  splashRadius: 1,
                  icon: Transform.rotate(
                      angle: isExpanded.isTrue ? pi : 0,
                      child: const Icon(Icons.arrow_drop_down_circle_rounded, size: 24, color: Colors.deepPurple)),
                  onPressed: () {
                    isExpanded.value = !isExpanded.value;
                    if (isExpanded.isTrue) {
                      _controller.forward();
                    } else {
                      _controller.reset();
                    }
                  },
                );
              }),
            ],
          ),
        ),
        SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            child: Column(
              children: [
                FontInfoWidget(font: widget._font!),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xfff3f3f3), borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            decoration:
                                const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffececec)))),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    I18n.fontSetting.tr,
                                    style: const TextStyle(fontSize: 18, color: Color(0xff151515)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  I18n.iconColor.tr,
                                  style: const TextStyle(fontSize: 15, color: Color(0xff151515)),
                                ),
                                Obx(() {
                                  return MaterialButton(
                                      onPressed: () {
                                        ColorPicker(
                                          color: iconColor.value,
                                          onColorChanged: (color) {
                                            iconColor.value = color;
                                          },
                                          pickersEnabled: const <ColorPickerType, bool>{
                                            ColorPickerType.both: false,
                                            ColorPickerType.primary: false,
                                            ColorPickerType.accent: false,
                                            ColorPickerType.bw: false,
                                            ColorPickerType.custom: false,
                                            ColorPickerType.wheel: true,
                                          },
                                          showColorCode: true,
                                          actionButtons: const ColorPickerActionButtons(dialogActionButtons: false),
                                        ).showPickerDialog(context);
                                      },
                                      color: iconColor.value,
                                      shape: const CircleBorder());
                                })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Scrollbar(
              radius: const Radius.circular(6),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 130, mainAxisExtent: 130, mainAxisSpacing: 6, crossAxisSpacing: 6),
                      physics: const BouncingScrollPhysics(),
                      itemCount: fontElements == null ? widget._font?.numGlyphs ?? 0 : fontElements?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xfff3f3f3),
                            elevation: 0,
                          ),
                          onPressed: () {
                            // todo show dialog with big icon、post
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(() {
                                  return Icon(
                                      IconData(
                                          fontElements == null
                                              ? widget._font?.cmap.glyphIndexToCodePointMap[index] ?? 0
                                              : fontElements?[index].codePoint ?? 0,
                                          fontFamily: widget._font?.uniqueFontFamily),
                                      size: 40,
                                      color: iconColor.value);
                                }),
                                Text(
                                  "&#${(fontElements == null ? widget._font?.cmap.glyphIndexToCodePointMap[index] ?? 0 : fontElements?[index].codePoint ?? 0).toRadixString(16)};",
                                  style: TextStyle(color: Color(0xff666666)),
                                ),
                                SubstringHighlight(
                                  text: fontElements == null
                                      ? widget._font?.post.glyphNames[index] ?? '-'
                                      : fontElements?[index].glyphName ?? '-',
                                  term: searchController.text,
                                  textStyle: TextStyle(
                                    color: Color(0xff666666),
                                  ),
                                  textStyleHighlight: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                        );
                      }),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
