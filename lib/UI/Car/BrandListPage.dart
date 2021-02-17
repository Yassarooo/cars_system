import 'package:flutter/material.dart';
import 'package:flutterapp/globals.dart' as globals;

class BrandsList extends StatefulWidget {
  @override
  _BrandsListState createState() => _BrandsListState();
}

class _BrandsListState extends State<BrandsList> {
  String _searchText = "";
  final TextEditingController _filter = new TextEditingController();
  List<String> filteredBrands = List<String>();
  final GlobalKey<ScaffoldState> brandscaffoldKey =
      new GlobalKey<ScaffoldState>();

  _BrandsListState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredBrands = globals.brands;
        });
      } else {
        setState(() {
          print(_filter.text);
          _searchText = _filter.text;
        });
        List<String> tempList = new List<String>();
        for (String item in filteredBrands) {
          if (item.toLowerCase().contains(_searchText.toLowerCase())) {
            tempList.add(item);
          }
        }
        setState(() {
          filteredBrands = tempList;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      filteredBrands = globals.brands;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSearchBar(BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: _filter,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: globals.kAccentColor,
              contentPadding: EdgeInsets.only(
                left: 30,
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 24.0, left: 16.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      key: brandscaffoldKey,
      backgroundColor: globals.kBackgroundColor,
      body: Container(
        //width: double.infinity,
        padding: EdgeInsets.fromLTRB(16, 35, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(33, 33, 33, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(
                        color: globals.kBackgroundColor,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                buildSearchBar(context),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "All Brands (" + filteredBrands.length.toString() + ")",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: GridView.count(
                physics: BouncingScrollPhysics(),
                //childAspectRatio: 1 / 1.55,
                crossAxisCount: 3,
                //crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                children: filteredBrands.map((item) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, item);
                      },
                      child: buildBrand(item, context));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildBrand(String brand, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: globals.kAccentColor,
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    margin: EdgeInsets.only(right: 10, left: 10),
    //width: MediaQuery.of(context).size.width,
    child: Align(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          brand,
          style: TextStyle(fontSize: 20),
        ),
      ),
    ),
  );
}
