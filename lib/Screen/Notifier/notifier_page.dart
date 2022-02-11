import 'package:flutter/material.dart';
import 'package:flutter_bulletin_board/Screen/Notifier/notifier_model.dart';
import 'package:flutter_bulletin_board/domain/notifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotifierPage extends StatefulWidget {
  const NotifierPage({Key? key}) : super(key: key);

  @override
  _NotifierPageState createState() => _NotifierPageState();
}

class _NotifierPageState extends State<NotifierPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotifierModel>(
      create: (_) => NotifierModel()..fetchNotifiers(),
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Consumer<NotifierModel>(builder: (context, model, child) {
            final List<Notifier>? notifiers = model.notifiers;

            if (notifiers == null) {
              return Center(
                child: Image.asset("assets/icon.png"),
              );
            }

            final List<Widget> widgets = notifiers
                .map((notifier) => ListTile(
                      leading: Text(notifier.title),
                      trailing: Text(
                        DateFormat(
                          'yyyy.MM.dd.kk:mm',
                        ).format(notifier.createdAt.toDate()).toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                      title: Text(notifier.description),
                      // subtitle: Container(
                      //   child: notifier.imgURL != null
                      //       ? Image.network(notifier.imgURL!)
                      //       : null,
                      // )
                    ))
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
      ),
    );
  }
}
