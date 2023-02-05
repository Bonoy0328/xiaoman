import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:global_configuration/global_configuration.dart';

void sendLikeMsg(bool isTrue, String name, String date) {
  Dio dio = Dio();

  dio.put(GlobalConfiguration().get("likeUrl"),
      data: {"isTrue": isTrue, "name": name, "date": date});
}

void sendShareMsg(bool isTrue, String name, String date) {
  Dio dio = Dio();

  dio.put(GlobalConfiguration().get("shareUrl"),
      data: {"isTrue": isTrue, "name": name, "date": date});
}

void sendFeedBack(String screenSize, String content) async {
  Dio dio = Dio();
  String ip = "127.0.0.1";
  late String mobileID;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print('Running on ${androidInfo.model}');
      mobileID = androidInfo.model as String;
    }
  } on PlatformException {
    mobileID = "error";
    // print("Error");
  }

  if (content == '') {
    Fluttertoast.showToast(
      msg: "内容不能为空",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  } else {
    await dio.put(GlobalConfiguration().get("facebackUrl"), data: {
      "IP": ip,
      "MobileID": mobileID,
      "ScreenSize": screenSize,
      "Content": content,
    });
    Fluttertoast.showToast(
      msg: "提交成功",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

Future<void> initPlatformState() async {}
