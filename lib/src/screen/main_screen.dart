import 'dart:developer';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../bean/font_file_wrapper.dart';
import '../i18n/i18n_value.dart';
import '../ttf_parser/ttf_parser.dart';
import '../widget/drop_file_area_widget.dart';
import '../widget/tab_body_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final List<TtfFont?> _fontList = List.empty(growable: true);
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _fontList.isEmpty ? 1 : _fontList.length, vsync: this);
  }

  Future<ChooseFontResultWrapper> _chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      // showErrorDialog(const Text('open File error'));
      return ChooseFontResultWrapper(bytes: null);
    }

    /// when open platformFile in web [result.files.first.path] is null, can not use [File]
    /// only [result.files.first.bytes] available
    var platformFile = result.files.first;
    if (kIsWeb) {
      return ChooseFontResultWrapper(
          bytes: platformFile.bytes, fileName: platformFile.name);
    } else {
      File ttfFile = File(platformFile.path!);
      return ChooseFontResultWrapper(
          bytes: await ttfFile.readAsBytes(), fileName: platformFile.name, filePath: platformFile.path);
    }
  }

  void _loadFont(ChooseFontResultWrapper wrapper) async {
    if (wrapper.bytes == null) {
      return;
    }
    TtfFont? newFont;
    try {
      newFont = TtfParser().parse(wrapper.bytes!)
        ..uniqueFontFamily = 'unique-font-family-${_fontList.length}'
        ..filePath = wrapper.filePath ?? '-'
        ..fileName = wrapper.fileName ?? '-';
      _fontList.add(newFont);
    } catch (e, s) {
      log("parse file error ${(s.toString())}", stackTrace: s);
      showErrorDialog(Text(I18n.parseFileError.tr));
      return;
    }
    log("load new font: fontName=${newFont.name.fontName}, fontFamily=${newFont.name.fontFamily}, subFamily=${newFont.name.subFamily}");
    FontLoader(newFont.uniqueFontFamily)
      ..addFont(readFontBytes(wrapper.bytes!))
      ..load();
    setState(() {
      _tabController = TabController(length: _fontList.length, vsync: this, initialIndex: _fontList.length - 1);
    });
  }

  void _chooseFileThenLoad() async {
    var wrapper = await _chooseFile();
    if (wrapper.bytes != null) {
      _loadFont(wrapper);
    }
  }

  void _dragFileThenLoad(DropDoneDetails details) async {
    for (var xFile in details.files) {
      _loadFont(ChooseFontResultWrapper(bytes: await xFile.readAsBytes(), fileName: xFile.name, filePath: kIsWeb ? '-' : xFile.path));
    }
  }

  Future<ByteData> readFontFile(File ttfFile) async {
    return (await ttfFile.readAsBytes()).buffer.asByteData();
  }

  Future<ByteData> readFontBytes(Uint8List bytes) async {
    return bytes.buffer.asByteData();
  }

  showErrorDialog(Widget title) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: const Icon(
              Icons.error,
              size: 40,
            ),
            iconColor: Colors.deepPurple,
            title: title,
            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(I18n.ok.tr))],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      // backgroundColor: const Color(0xff202123),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 10),
        child: DropTarget(
            onDragDone: (DropDoneDetails detail) => _dragFileThenLoad(detail),
            child: _fontList.isEmpty
                ? const DropFileAreaWidget()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: TabBar(
                          splashBorderRadius: BorderRadius.circular(12),
                          isScrollable: true,
                          labelColor: Colors.deepPurple,
                          tabs: _fontList
                              .map((e) => Tab(
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 6),
                                          child: Icon(
                                            Icons.font_download_rounded,
                                            size: 18,
                                          ),
                                        ),
                                        Text(
                                          e?.name.fontName ?? 'noname',
                                          style: TextStyle(color: Colors.deepPurple),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          controller: _tabController,
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TabBarView(
                            controller: _tabController,
                            children: _fontList
                                .asMap()
                                .map((key, value) => MapEntry(
                                    key,
                                    TabBodyWidget(
                                      font: value,
                                    )))
                                .values
                                .toList()),
                      ))
                    ],
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _chooseFileThenLoad,
        tooltip: I18n.fabTip.tr,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
