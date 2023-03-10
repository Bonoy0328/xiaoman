import 'package:flutter/material.dart';
import 'package:xiaoman/widgets/dividing_line.dart';
import 'package:xiaoman/widgets/like_share_button.dart';
import '../models/article.dart';
import '../models/enum.dart';

// ignore: must_be_immutable
class ArticlePage extends StatefulWidget {
  Article article;
  ArticlePage(this.article, {Key? key}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.article.date.split("-")[1] +
                  "月" +
                  widget.article.date.split("-")[2] +
                  "日的 文",
              style: Theme.of(context).textTheme.headline1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.article.title,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.article.author,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                "http://www.bonoy0328.com/media/" + widget.article.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.article.content,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            dividingLine(context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Container(
              // color: Colors.pink,
              child: likeShareButton(ButtonId.music, widget.article.likes,
                  widget.article.shares, widget.article.date),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
