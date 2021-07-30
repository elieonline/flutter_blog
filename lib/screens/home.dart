import 'package:flutter/material.dart';
import 'package:flutter_blog/helpers/funtions.dart';
import 'package:flutter_blog/helpers/services.dart';
import 'package:flutter_blog/models/post.dart';
import 'package:flutter_blog/models/post_model.dart';
import 'package:flutter_blog/screens/new_post.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _appBarTitle =
      Text("Flutter Blog", style: TextStyle(color: Color(0xFF8A0202)));
  IconData _searchIcon = Icons.search;
  String _searchText = "";
  TextEditingController _searchController = new TextEditingController();

  bool _isBuilding = false;

  List<Post> _filteredPosts = [];

  void _getPosts() async {
    setState(() {
      _isBuilding = true;
    });

    final response = await postList(); //fetchint posts from api
    for (Post item in response) {
      Provider.of<PostModel>(context, listen: false).add(item);
    }

    setState(() {
      _filteredPosts = Provider.of<PostModel>(context, listen: false).items;
      _isBuilding = false;
    });
  }

  _HomeState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _searchText = "";
          _filteredPosts = Provider.of<PostModel>(context, listen: false).items;
        });
      } else {
        setState(() {
          _searchText = _searchController.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _appBarTitle,
        actions: [
          IconButton(
              icon: Icon(
                _searchIcon,
                color: theme.primaryColor,
              ),
              onPressed: () {
                setState(() {
                  if (_searchIcon == Icons.search) {
                    _searchIcon = Icons.close;
                    _appBarTitle = TextField(
                      autofocus: true,
                      controller: _searchController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(hintText: "Search..."),
                    );
                  } else {
                    _searchIcon = Icons.search;
                    _appBarTitle = Text("Flutter Blog",
                        style: TextStyle(color: Color(0xFF8A0202)));
                    _searchController.clear();
                  }
                });
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Top Headlines",
              style: theme.textTheme.headline6,
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height - 150,
              child: _buildList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewPost())),
      ),
    );
  }

  Widget _buildList() {
    List<Post> posts = Provider.of<PostModel>(context, listen: false).items;
    if (_searchText.isNotEmpty) {
      List<Post> tempList = [];
      for (Post post in posts) {
        if (post.title!.toLowerCase().contains(_searchText.toLowerCase()) ||
            post.body!.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(post);
        }
      }
      setState(() {
        _filteredPosts = tempList;
      });
    }

    if (_isBuilding) {
      return ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.white,
                child: dummyList(),
              ));
    }

    if (_filteredPosts.isEmpty && !_isBuilding) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No post found",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold))
          ],
        ),
      );
    }

    return ListView.builder(
        itemCount: _filteredPosts.length,
        itemBuilder: (context, index) {
          Post post = _filteredPosts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                )),
                elevation: 3,
                child: GestureDetector(
                  child: postContent(post),
                )),
          );
        });
  }

  Widget dummyList() {
    return ListTile(
      isThreeLine: true,
      title: Container(height: 8.0, color: Colors.white),
      subtitle: Container(height: 8.0, color: Colors.white),
      trailing: Container(
        width: 40,
        height: 8.0,
        color: Colors.white,
      ),
    );
  }

  Widget postContent(Post post) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              height: 160,
              child: Center(child: Text("Image")),
              color: Colors.blueGrey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
                child: Text("Fri 30, Jul 2021"),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${post.title!.titleCase}",
                style: Theme.of(context).textTheme.headline6,
                //textAlign: TextAlign.justify,
              ),
              SizedBox(height: 10),
              Text(
                "${post.body!.sentenceCase.replaceAll("\n", "")}",
                textAlign: TextAlign.justify,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Author ${post.userId}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "8 hours ago",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}
