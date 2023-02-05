import 'package:flutter/foundation.dart';
import 'models/article.dart';
import 'models/music.dart';
import 'models/poetry.dart';
import 'package:dio/dio.dart';
import 'package:global_configuration/global_configuration.dart';

class DataManager with ChangeNotifier {
  late Poetry poetry;
  late Music music;
  late Article article;
  bool dataIsReady = false;

  Dio dio = Dio();

  void getData() async {
    int dataCount = 0;

    DateTime dateTime = DateTime.now().add(const Duration(hours: 8));
    String mouth = dateTime.month.toString();
    if (mouth.length == 1) mouth = "0" + dateTime.month.toString();
    String days = dateTime.day.toString();
    if (days.length == 1) days = "0" + dateTime.day.toString();
    String date = dateTime.year.toString() + "-" + mouth + "-" + days;
    print(date);

    Response response = await dio.get(GlobalConfiguration().get("peotryUrl"),
        queryParameters: {"date": date});
    if (response.data["ID"] == null) {
      poetry = Poetry(
          author: "null",
          content: "null",
          date: "null",
          id: 0,
          likes: 0,
          shares: 0);
      print("poerty data is Bad!");
    } else {
      poetry = Poetry(
          author: response.data["poetryAuthor"],
          content: response.data["poetryContent"],
          date: response.data["Date"],
          id: response.data["ID"],
          likes: response.data["LikesNum"],
          shares: response.data["SharedNum"]);
      print("poerty data is OK!");
      dataCount++;
    }
    print(response.data);

    response = await dio.get(GlobalConfiguration().get("musicUrl"),
        queryParameters: {"date": date});
    if (response.data["ID"] == null) {
      print("music data is Bad!");
      music = Music(
          id: 0,
          date: "null",
          file: "null",
          image: "null",
          author: "null",
          name: "null",
          likes: 0,
          shares: 0);
    } else {
      music = Music(
          id: response.data["ID"],
          date: response.data["Date"],
          file: response.data["musicfile"].split("media/")[1],
          image: response.data["musicImg"].split("media/")[1],
          author: response.data["anthorName"],
          name: response.data["musicName"],
          likes: response.data["LikesNum"],
          shares: response.data["SharedNum"]);

      print("music data is OK!");
      dataCount++;
    }
    print(response.data);

    response = await dio.get(GlobalConfiguration().get("articleUrl"),
        queryParameters: {"date": date});
    if (response.data["ID"] == null) {
      print("article data is Bad!");
      article = Article(
          author: "null",
          content: "null",
          date: "null",
          id: 0,
          image: "null",
          title: "null",
          likes: 0,
          shares: 0);
    } else {
      article = Article(
          author: response.data["articleAnthor"],
          content: response.data["articleContent"],
          date: response.data["Date"],
          id: response.data["ID"],
          image: response.data["articleImg"].split("media/")[1],
          title: response.data["articleTitle"],
          likes: response.data["LikesNum"],
          shares: response.data["SharedNum"]);
      print("article data is OK!");
      dataCount++;
    }
    if (dataCount == 3) {
      dataIsReady = true;
    } else {
      dataIsReady = false;
    }
    notifyListeners();
  }
}

// Future<Map<String, Object>> dataManager(String date) async {
//   Poetry poetry = Poetry(
//     id: 0,
//     date: "date",
//     content: "",
//     author: "author",
//     likes: 0,
//     shares: 0,
//   );
//   Music music = Music(
//       id: 0,
//       date: "date",
//       image: "image",
//       name: "name",
//       author: "author",
//       file: "file",
//       likes: 0,
//       shares: 0);
//   Article article = Article(
//       id: 0,
//       date: "date",
//       title: "title",
//       author: "author",
//       image: "image",
//       content: "content",
//       likes: 0,
//       shares: 0);
//   Map<String, Object> resDict = {
//     "poetry": poetry,
//     "music": music,
//     "article": article,
//   };
//   bool isInitiateRequest = false;
//   // String contentDate = " ";

//   Dio dio = Dio();
//   // check local time is match database time
//   // if true don't initiate network request
//   // SharedPreferences prefs = await SharedPreferences.getInstance();
//   // var contentDate = prefs.getString("contentDate");
//   // if (contentDate == null) {
//   //   print("initiate request");
//   //   isInitiateRequest = true;
//   // } else {}
// // Date: "2021-6-2-21:58"
// // ID: 1
// // LikesNum: 2
// // SharedNum: 5
// // UpdatorName: "bonoy"
// // poetryAuthor: "佚名"
// // poetryContent: "我的豪迈烈骨给你看了，\n我的魅惑风情也被你收了，\n你要拿什么还我？\n诗人的情诗我自是不信的，\n我要你这浪子的余生。"

//   print(date);

//   Response response = await dio.get("http://www.bonoy0328.com/getPoetry",
//       queryParameters: {"date": date});
//   if (response.data["ID"] == null) {
//     print("poerty data is Bad!");
//   } else {
//     poetry.author = response.data["poetryAuthor"];
//     poetry.content = response.data["poetryContent"];
//     poetry.date = response.data["Date"];
//     poetry.id = response.data["ID"];
//     poetry.likes = response.data["LikesNum"];
//     poetry.shares = response.data["SharedNum"];
//     print("poerty data is OK!");
//   }
//   print(response.data);

// // Date: "2021-6-8-21:21:21"
// // ID: 1
// // LikesNum: 1
// // SharedNum: 3
// // UpdatorName: "bonoy"
// // anthorName: "bonoy"
// // musicImg: "/usr/local/bonoy/media/music/img/Doja Cat; SZA - Kiss Me More.PNG"
// // musicName: "Doja Cat; SZA - Kiss Me More"
// // musicfile: "/usr/local/bonoy/media/music/musicFile/Doja Cat; SZA - Kiss Me More.mp3"
//   response = await dio.get("http://www.bonoy0328.com/getMusic",
//       queryParameters: {"date": date});
//   if (response.data["ID"] == null) {
//     print("music data is Bad!");
//   } else {
//     music.id = response.data["ID"];
//     music.date = response.data["Date"];
//     music.file = response.data["musicfile"].split("media/")[1];
//     music.image = response.data["musicImg"].split("media/")[1];
//     music.author = response.data["anthorName"];
//     music.name = response.data["musicName"];
//     music.likes = response.data["LikesNum"];
//     music.shares = response.data["SharedNum"];
//     print("music data is OK!");
//   }
//   print(response.data);
//   // download music to local
// // ArticleAnthor: "me"
// // Date: "2021-5-30-23:21:50"
// // ID: 1
// // LikesNum: 1
// // SharedNum: 4
// // UpdatorName: "bonoy"
// // articleContent: "《印度哲学概论》至：“太子作狮子吼：‘我若不断生、老、病、死、优悲、苦恼，不得阿耨多罗三藐三菩提，要不还此。’”有感而作。我刚刚出了世，已经有了一个漆黑严密的圈儿，远远的罩定我，但是我不觉得。渐的我往外发展，就觉得有它限制阻抑着，并且它似乎也往里收缩─—好害怕啊！圈子里只有黑暗，苦恼悲伤。　　　　它往里收缩一点，我便起来沿着边儿奔走呼号一回。结果呢？它依旧严严密密的罩定我，我也只有屏声静气的，站在当中，不能再动。　　　　它又往里收缩一点，我又起来沿着边儿奔走呼号一回；回数多了，我也疲乏了，─—圈儿啊！难道我至终不能抵抗你？永远幽囚在这里面么？　　　　起来！忍耐！努力！　　　　呀！严密的圈儿，终竟裂了一缝。─—往外看时，圈子外只有光明，快乐，自由。─—只要我能跳出圈儿外！　　《印度哲学概论》至：“太子作狮子吼：‘我若不断生、老、病、死、优悲、苦恼，不得阿耨多罗三藐三菩提，要不还此。’”有感而作。我刚刚出了世，已经有了一个漆黑严密的圈儿，远远的罩定我，但是我不觉得。渐的我往外发展，就觉得有它限制阻抑着，并且它似乎也往里收缩─—好害怕啊！圈子里只有黑暗，苦恼悲伤。 　　它往里收缩一点，我便起来沿着边儿奔走呼号一回。结果呢？它依旧严严密密的罩定我，我也只有屏声静气的，站在当中，不能再动。 　　它又往里收缩一点，我又起来沿着边儿奔走呼号一回；回数多了，我也疲乏了，─—圈儿啊！难道我至终不能抵抗你？永远幽囚在这里面么？ 　　起来！忍耐！努力！　　 　　呀！严密的圈儿，终竟裂了一缝。─—往外看时，圈子外只有光明，快乐，自由。─—只要我能跳出圈儿外！ 　　前途有了希望了，我不是永远不能抵抗它，我不至于永远幽囚在这里面了。努力！忍耐！看我劈开了这苦恼悲伤，跳出圈儿外！"
// // articleImg: "/usr/local/bonoy/media/article/img/Ydata_fAIvGPh.png"
// // articleTitle: "我是你爸爸"
// // url is "www.bonoy0328.com/media/article/img/Ydata_fAIvGPh.png"
//   response = await dio.get("http://www.bonoy0328.com/getArticle",
//       queryParameters: {"date": date});
//   if (response.data["ID"] == null) {
//     print("article data is Bad!");
//   } else {
//     article.author = response.data["articleAnthor"];
//     article.content = response.data["articleContent"];
//     article.date = response.data["Date"];
//     article.id = response.data["ID"];
//     article.image = response.data["articleImg"].split("media/")[1];
//     article.title = response.data["articleTitle"];
//     article.likes = response.data["LikesNum"];
//     article.shares = response.data["SharedNum"];
//     print("article data is OK!");
//   }
//   return resDict;
// }
