import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../models/music.dart';
import '../models/poetry.dart';
import '../screens/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sized_context/sized_context.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data_manager.dart';
import 'login_screen.dart';

class BootPage extends StatefulWidget {
  static const String routeName = "/boot";

  const BootPage({Key? key}) : super(key: key);

  @override
  _BootPageState createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  double lineMarginTop = 10;
  bool initSuccess = false;
  int timeoutCnt = 0;
  late Article article;
  late Music music;
  late Poetry poetry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      // var status = await Permission.location.status;
      // if (status.isLimited || status.isDenied || status.isRestricted) {
      //   if (await Permission.location.request().isGranted) {
      //     // Either the permission was already granted before or the user just granted it.
      //   }
      // }

      timeoutCnt++;
      if (timeoutCnt >= 2) {
        if (initSuccess) {
          timer.cancel();
          print("navigator to home page");
          Navigator.of(context).push(
            // PageRouteBuilder(
            //   pageBuilder: ((context, animation, secondaryAnimation) =>
            //       HomePage(article, music, poetry)),
            // ),
            PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) =>
                  MyLogin()),
            ),
          );
        } else {
          if (timeoutCnt == 5) {
            Fluttertoast.showToast(
                msg: "网络超时，请稍后重试",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black45,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _dataProvider = context.watch<DataManager>();
    if (!_dataProvider.dataIsReady) {
      _dataProvider.getData();
      initSuccess = false;
    } else {
      if (!initSuccess) {
        article = _dataProvider.article;
        music = _dataProvider.music;
        poetry = _dataProvider.poetry;
        initSuccess = true;
      }
    }
    print("rebuild");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF3F3F1),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.widthPx * 0.5964),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/xiao.svg",
                  fit: BoxFit.cover,
                  width: context.widthPx * 0.152,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: context.widthPx * 0.152 * 0.5761,
                  ),
                  child: SvgPicture.asset(
                    "assets/images/man.svg",
                    fit: BoxFit.cover,
                    width: context.widthPx * 0.152,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: SvgPicture.asset(
                  "assets/images/by.svg",
                  fit: BoxFit.cover,
                  width: context.widthPx * 0.1947,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
