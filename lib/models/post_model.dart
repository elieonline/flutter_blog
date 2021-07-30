import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_blog/models/post.dart';

class PostModel extends ChangeNotifier {
  final List<Post> _posts = [];
  UnmodifiableListView<Post> get items => UnmodifiableListView(_posts);

  void add(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  int get length => _posts.length;
}
