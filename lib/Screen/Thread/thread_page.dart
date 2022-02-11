import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bulletin_board/Screen/Add/add_post_page.dart';
import 'package:flutter_bulletin_board/Screen/Thread/thread_model.dart';
import 'package:flutter_bulletin_board/domain/post.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ThreadPage extends StatefulWidget {
  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final TextEditingController searchController = TextEditingController();

  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    final postDefaultStyle = TextStyle(color: Colors.green, fontSize: 20);
    return ChangeNotifierProvider<ThreadModel>(
      create: (_) => ThreadModel()..fetchThread(),
      child: Scaffold(
        appBar: AppBar(
          title: Form(
              child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(labelText: '本検索'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
          )),
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where(
                      'description',
                      isGreaterThanOrEqualTo: searchController.text,
                    )
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          print(
                            (snapshot.data! as dynamic).docs[index]['name'],
                          );
                        },
                        child: ListTile(
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['description'],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : Center(
                child: Consumer<ThreadModel>(builder: (context, model, child) {
                  final List<Post>? posts = model.posts;

                  if (posts == null) {
                    return Center(
                      child: Image.asset("assets/icon.png"),
                    );
                  }

                  final List<Widget> widgets = posts
                      .map(
                        (post) => ListTile(
                          title: Row(
                            children: [
                              Text(post.index.toString() + "  "),
                              Container(
                                child: post.name != null
                                    ? Text(
                                        post.name! + " Q",
                                        style: postDefaultStyle,
                                      )
                                    : Text(
                                        "名無し Q",
                                        style: postDefaultStyle,
                                      ),
                              ),
                              Text(
                                DateFormat(
                                  'yyyy.MM.dd.kk:mm',
                                ).format(post.createdAt.toDate()).toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                              IconButton(
                                icon: Icon(Icons.favorite_outline_outlined),
                                onPressed: () {
                                  model.favoriteButton(post.id, post.fav);
                                },
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.description,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 23),
                                ),
                                Container(
                                  child: post.imgURL != null
                                      ? Image.network(post.imgURL!)
                                      : null,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList();
                  return ListView(
                    children: widgets,
                  );
                }),
              ),
        floatingActionButton:
            Consumer<ThreadModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              // 画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPostPage(),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('本を追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              model.fetchThread();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }
}
