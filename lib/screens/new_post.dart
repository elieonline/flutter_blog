import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/models/post.dart';
import 'package:flutter_blog/models/post_model.dart';
import 'package:provider/provider.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      padding: EdgeInsets.all(20),
      child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Container(
                  width: 70,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "New Post",
                    style: TextStyle(
                        fontSize: 18,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              formField(
                controller: _titleController,
                label: "Title",
                hint: "Post Title",
                validator: (value) {
                  if (value!.isEmpty) return "This field required";
                  return null;
                },
              ),
              formField(
                controller: _descriptionController,
                label: "Description",
                hint: "Write Something here...",
                minLines: 6,
                validator: (value) {
                  if (value!.isEmpty) return "This field required";
                  return null;
                },
              ),
              SizedBox(height: 20),
              CupertinoButton.filled(
                padding: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width / 2) - 40),
                borderRadius: BorderRadius.circular(5),
                child: Text('Post'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<PostModel>(context, listen: false).add(Post(
                      userId: Random().nextInt(20),
                      id: Random(101).nextInt(200),
                      title: _titleController.text,
                      body: _descriptionController.text,
                    ));
                    _titleController.clear();
                    _descriptionController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Post successfully added")));
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          )),
    );
  }

  Widget formField({
    TextEditingController? controller,
    String? label,
    String? hint,
    int? minLines,
    String? Function(String?)? validator,
  }) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text("$label", style: TextStyle(fontSize: 16)),
          TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            minLines: minLines,
            maxLines: null,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
