import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/data/category_data.dart';
import 'package:news_app/data/news_data.dart';
import 'package:news_app/models/articel_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/screens/articel_screen.dart';
import 'package:news_app/screens/catagory_screen.dart';

CategoryData categoryData = CategoryData();

class HomeScreens extends StatefulWidget {
  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  List<ArticelModel> listArticel = new List<ArticelModel>();
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _getNews();
  }

  _getNews() async {
    NewsData newsData = NewsData();
    await newsData.getNews();
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
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    //categories
                    Container(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryData.getDataCategory.length,
                        itemBuilder: (context, int index) {
                          CategoryModel categoryModel =
                              categoryData.getDataCategory[index];
                          return CategoryTile(
                            imgUrl: categoryModel.imgUrl,
                            categoryName: categoryModel.categoryName,
                          );
                        },
                      ),
                    ),
                    //listArticel
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

class CategoryTile extends StatelessWidget {
  final String imgUrl, categoryName;
  CategoryTile({this.imgUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreens(
              category: categoryName.toLowerCase(),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.cover,
                width: 120,
                height: 60,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
            ),
            Container(
              width: 120,
              height: 60,
              alignment: Alignment.center,
              child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
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
              height: MediaQuery.of(context).size.height*0.22,
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
                  child: Image(
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height*0.22,image: NetworkImage(imgUrl),),),
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
