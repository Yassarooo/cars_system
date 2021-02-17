import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Data/API.dart';
import 'package:flutterapp/globals.dart' as globals;

class ParamsPHWidget extends StatefulWidget {
  @override
  _ParamsPHWidgetState createState() => _ParamsPHWidgetState();
}

class _ParamsPHWidgetState extends State<ParamsPHWidget> {
  ApiManager apiManager = ApiManager();
  Timer timer;
  bool _isloading = true;

  GlobalKey<ScaffoldState> _paramScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getData();
    //timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fetchParams());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _getData() async {
    _isloading = true;
    bool success = await apiManager.fetchParams();
    if (success)
      setState(() {
        globals.paramsobj = globals.paramsobj;
        _isloading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _paramScaffoldKey,
      backgroundColor: globals.kBackgroundColor,
      body: Container(
        child: !_isloading
            ? RefreshIndicator(
                child: ListView.builder(
                  itemCount: globals.paramsobj.params == null
                      ? 0
                      : globals.paramsobj.params.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Card(
                          color: Colors.black87,
                          shadowColor: Colors.pink,
                          elevation: 6,
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 8.0,
                                ),
                                ListTile(
                                  isThreeLine: true,
                                  leading: Icon(Icons.format_indent_increase),
                                  title: Text(
                                    globals.paramsobj.params[index].name,
                                    textAlign: TextAlign.justify,
                                  ),
                                  subtitle: Text(
                                    "Seats: " +
                                        globals.paramsobj.params[index].seats
                                            .toString() +
                                        "\nPercentage: " +
                                        globals.paramsobj.params[index].percent
                                            .toString() +
                                        "%",
                                    textAlign: TextAlign.justify,
                                  ),
                                  trailing: Wrap(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          await apiManager.deleteParam(
                                              globals
                                                  .paramsobj.params[index].id,
                                              context,
                                              _paramScaffoldKey);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.white70),
                                        onPressed: () async {
                                          await apiManager.editParam(
                                              globals
                                                  .paramsobj.params[index].id,
                                              index,
                                              context,
                                              _paramScaffoldKey);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                ),
                onRefresh: _getData,
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
