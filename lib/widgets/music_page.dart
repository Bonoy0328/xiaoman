import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:sized_context/sized_context.dart';
import '../models/music.dart';
import 'dividing_line.dart';
import 'like_share_button.dart';
import '../models/enum.dart';
import 'package:just_audio/just_audio.dart';

// ignore: must_be_immutable
class MusicPage extends StatefulWidget {
  Music music;

  MusicPage(
    this.music, {
    Key? key,
  }) : super(key: key);

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>
    with SingleTickerProviderStateMixin {
  final _player = AudioPlayer();
  late Duration _duration;

  final Tween<double> _rotationTween = Tween(begin: 0, end: math.pi * 2);
  late AnimationController _rotationAniCtr;

  bool _isLike = false;

  Container networkSongTmg(String imgDir) {
    return Container(
      width: context.widthPx * 0.85227,
      height: context.widthPx * 0.85227 * 1.28378,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          spreadRadius: 1,
          blurRadius: 20,
          offset: Offset(0, 0),
        ),
      ]),
      // child: Image(
      //   width: double.infinity,
      //   height: double.infinity,
      //   // image: FileImage(File(imgDir)),
      // ),
      child: Image.network(imgDir),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _rotationAniCtr =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _rotationAniCtr.addListener(
      () {
        setState(() {});
      },
    );

    print("https://www.bonoy0328.com/media/" + widget.music.file);
    Timer(Duration.zero, () async {
      _duration = (await _player
          .setUrl("https://www.bonoy0328.com/media/" + widget.music.file))!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: networkSongTmg(
                "http://www.bonoy0328.com/media/" + widget.music.image),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: context.widthPx * 0.073865,
              ),
              Transform.rotate(
                angle: _rotationTween
                    .animate(CurvedAnimation(
                        parent: _rotationAniCtr, curve: Curves.linear))
                    .value,
                child: LikeButton(
                  size: 40,
                  animationDuration: const Duration(milliseconds: 500),
                  circleColor: const CircleColor(
                      start: Color(0xff00ddff), end: Color(0xff0099cc)),
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      _isLike
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                      color: _isLike ? Colors.deepPurpleAccent : Colors.grey,
                      size: 30,
                    );
                  },
                  onTap: (isLiked) async {
                    if (!_isLike) {
                      _isLike = true;
                      print("play music");
                      _rotationAniCtr.repeat();

                      Timer(Duration.zero, () async {
                        await _player.play();
                      });
                    } else {
                      _isLike = false;
                      print("stop music");
                      _rotationAniCtr.stop();
                      _rotationAniCtr.reset();
                      Timer(Duration.zero, () async {
                        await _player.stop();
                      });
                    }
                    return !isLiked;
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              Text(
                "Doja Cat; SZA \n Kiss Me More",
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                width: context.widthPx * 0.073865,
              ),
            ],
          ),
          dividingLine(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Container(
              // color: Colors.pink,
              child: likeShareButton(ButtonId.music, widget.music.likes,
                  widget.music.shares, widget.music.date),
            ),
          ),
        ],
      ),
    );
  }
}
