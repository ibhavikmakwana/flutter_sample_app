import 'package:flutter/material.dart';
import 'package:flutter_sample_app/data/response.dart';

class Detail extends StatelessWidget {
  final Items item;

  Detail(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: item.owner.avatarUrl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        item.owner.avatarUrl,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                        item.fullName,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ],
                ),
              ),
              getRows(Icons.warning, "Issues: "+item.openIssues.toString(), context),
              getRows(Icons.get_app, "Forked: "+item.forksCount.toString(), context),
              getRows(Icons.remove_red_eye, "Watched: " +item.watchers.toString(), context),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Score count: ${item.score}",
                  style: Theme.of(context).textTheme.title,
                  softWrap: true,
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  item.description,
                  softWrap: true,
                  style: Theme.of(context).textTheme.body2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getRows(IconData icon, String data, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(icon),
          ),
          Text(
            data,
            style: Theme.of(context).textTheme.title,
          ),
        ],
      ),
    );
  }
}
