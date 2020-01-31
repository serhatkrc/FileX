import 'dart:io';

import 'package:filex/providers/category_provider.dart';
import 'package:filex/util/consts.dart';
import 'package:filex/widgets/file_item.dart';
import 'package:filex/widgets/sort_sheet.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Downloads extends StatelessWidget {
  final String title;

  Downloads({
    Key key,
    @required this.title,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    getDownloads() async{
      List<FileSystemEntity> downloads = List();
      List<FileSystemEntity> l = await getExternalStorageDirectories();
      l.forEach((v){
        Directory dir = Directory(v.path.split("Android")[0]+"Download");
        downloads.addAll(dir.listSync());
      });
    }

    return Consumer(
      builder: (BuildContext context, CategoryProvider provider, Widget child) {
        return DefaultTabController(
          length: provider.downloadTabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "$title",
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SortSheet(),
                    );
                  },
                  tooltip: "Sort by",
                  icon: Icon(
                    Icons.sort,
                  ),
                ),
              ],
              bottom: TabBar(
                indicatorColor: Theme.of(context).accentColor,
                labelColor: Theme.of(context).accentColor,
                unselectedLabelColor: Theme.of(context).textTheme.caption.color,
                isScrollable: false,
                tabs: Constants.map<Widget>(
                  provider.downloadTabs,
                      (index, label){
                    return Tab(
                      text: "$label",
                    );
                  },
                ),
              ),
            ),

            body: TabBarView(
              children: Constants.map<Widget>(
                provider.downloadTabs,
                    (index, label){
                  return ListView.separated(
                    padding: EdgeInsets.only(left: 20),
                    itemCount: provider.downloads.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(provider.downloadTabs);
                      return FileItem(
                        file: provider.downloads[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 1,
                              color: Theme.of(context).dividerColor,
                              width: MediaQuery.of(context).size.width - 70,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
