import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../i18n/i18n_value.dart';

class FontSettingController extends GetxController {
  /// code point format list: html/unicode
  final codePointToggleList = [true, false].obs;
  final gridItemSize = 130.0.obs;
  final iconColor = Color(Colors.black.value).obs;

  void showColorPickerDialog(BuildContext context) {
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
  }
}

class FontSettingWidget extends StatelessWidget {
  final String controllerTag;

  const FontSettingWidget({required this.controllerTag, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FontSettingController fontSettingController = Get.find(tag: controllerTag);
    return Padding(
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
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffececec)))),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Obx(() {
                        return MaterialButton(
                            onPressed: () {
                              fontSettingController.showColorPickerDialog(context);
                            },
                            color: fontSettingController.iconColor.value,
                            shape: const CircleBorder());
                      }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      I18n.codePointType.tr,
                      style: const TextStyle(fontSize: 15, color: Color(0xff151515)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 27.0),
                      child: Obx(() {
                        return ToggleButtons(
                          constraints: const BoxConstraints(maxHeight: 40),
                          borderRadius: BorderRadius.circular(10),
                          isSelected: fontSettingController.codePointToggleList,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 8),
                              child: Text('HTML'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 8),
                              child: Text('Unicode'),
                            )
                          ],
                          onPressed: (index) {
                            fontSettingController.codePointToggleList.value =
                            fontSettingController.codePointToggleList.map((e) => false).toList()
                              ..[index] = true;
                          },
                        );
                      }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      I18n.gridItemSize.tr,
                      style: const TextStyle(fontSize: 15, color: Color(0xff151515)),
                    ),
                    SizedBox(
                      height: 30,
                      child: Obx(() {
                        return Slider(
                            value: fontSettingController.gridItemSize.value,
                            min: 130,
                            max: 270,
                            onChanged: (changedValue) {
                              fontSettingController.gridItemSize.value = changedValue;
                            });
                      }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
