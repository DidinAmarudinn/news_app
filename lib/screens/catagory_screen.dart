import 'package:flutter/material.dart';
import 'package:news_app/data/news_data.dart';
import 'package:news_app/models/articel_model.dart';
import 'package:news_app/screens/articel_screen.dart';

class CategoryScreens extends StatefulWidget {
  final String category;
  CategoryScreens({@required this.category});
  @override
  _CategoryScreensState createState() => _CategoryScreensState();
}

class _CategoryScreensState extends State<CategoryScreens> {
  List<ArticelModel> listArticel = new List<ArticelModel>();
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _getCategoryNews();
  }

  _getCategoryNews() async {
    CategoryNews newsData = CategoryNews();
    await newsData.getNews(widget.category);
    listArticel = newsData.news;
    print(listArticel);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Flutter",
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.desktop_windows),
              ),
            ),
          )
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        itemCount: listArticel.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, int index) {
                          return BlogTile(
                            imgUrl: listArticel[index].urlToImage,
                            title: listArticel[index].titile,
                            desc: listArticel[index].description,
                            url: listArticel[index].url,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class BlogTile extends StatelessWidget {
  @override
  final String imgUrl, title, desc, url;
  BlogTile({this.title, this.imgUrl, this.desc, @required this.url});
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticelScreens(
              url: url,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.22,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.12),
                        offset: Offset(0, 2),
                        blurRadius: 2)
                  ]),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(fit: BoxFit.cover,height: MediaQuery.of(context).size.height * 0.22, image: NetworkImage(imgUrl))),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              title.toString(),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              desc.toString(),
              style: TextStyle(color: Colors.black54),
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}
