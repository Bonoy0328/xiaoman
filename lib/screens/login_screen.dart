import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  String phoneNum = "";
  String password = "";

  TextEditingController _phoneNumtextController = TextEditingController();
  TextEditingController _passwordtextController = TextEditingController();
  late Future<String> _phoneNum, _password;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var dio = Dio();

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void getusrPswVerification(String phoneNum, String password) async {
    if (phoneNum == "" || password == "") {
      phoneNum = await _phoneNum;
      password = await _password;
    }
    if (phoneNum == "" || password == "") {
      showToast("账户不存在或秘密错误");
      return;
    }
    var qParam = {"phoneNum": phoneNum, "password": password};
    var response = await dio.get(
        "http://www.bonoy0328.com/pvis/getVerificationPhoneNumPassword",
        queryParameters: qParam);
    await _setPhoneNum(phoneNum);
    await _setPassword(password);
    if (response.data["status"] == "true") {
      Navigator.pushNamed(context, "bluetooth", arguments: qParam);
    } else {
      showToast(response.data["status"]);
    }

    // print(response.data["status"]);
  }

  Future<void> _setPhoneNum(String PhoneNum) async {
    final SharedPreferences prefs = await _prefs;
    _phoneNum = prefs.setString("phoneNum", PhoneNum).then((value) => PhoneNum);
  }

  Future<void> _setPassword(String password) async {
    final SharedPreferences prefs = await _prefs;
    _password = prefs.setString("password", password).then((value) => password);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNum = _prefs.then((value) {
      return value.getString("phoneNum") ?? "";
    });
    _password = _prefs.then((value) {
      return value.getString("password") ?? "";
    });
    print(_phoneNum.toString());
    print(_password.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/login.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 130),
            child: const Text(
              'Welcome\nBack',
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                  right: 35,
                  left: 35),
              child: Column(
                children: [
                  FutureBuilder(
                      future: _phoneNum,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return TextField(
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: snapshot.data ?? "",
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset:
                                              snapshot.data?.length ?? 0)))),
                          onChanged: (value) {
                            phoneNum = value;
                            _setPhoneNum(phoneNum);
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: '昵称',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  FutureBuilder(
                      future: _password,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return TextField(
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: snapshot.data ?? "",
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset:
                                              snapshot.data?.length ?? 0)))),
                          onChanged: (value) {
                            password = value;
                            _setPassword(password);
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: '密码',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "登陆",
                        style: TextStyle(
                          color: Color(0xff4c505b),
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff4c505b),
                        child: IconButton(
                          onPressed: () {
                            getusrPswVerification(phoneNum, password);
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "register");
                        },
                        child: const Text(
                          "注册",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff4c505b),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showToast("此功能暂未开发");
                        },
                        child: const Text(
                          "忘记密码",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff4c505b),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
