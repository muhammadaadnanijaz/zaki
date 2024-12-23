import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaki/Constants/Styles.dart';

import '../Constants/AppConstants.dart';
import '../Constants/HelperFunctions.dart';
import 'TextHeader.dart';


class SelectCounteryState extends StatefulWidget {
  final List<String>? listItems;
  SelectCounteryState({this.listItems});
  @override
  _SelectCounteryState createState() => _SelectCounteryState();
}

class _SelectCounteryState extends State<SelectCounteryState> {
  List<String>? filteredItems;

  @override
  void initState() {
    super.initState();
    filteredItems = widget. listItems;
  }

  void _filterItems(String value) {
    setState(() {
      filteredItems = widget. listItems!
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    var appConstants = Provider.of<AppConstants>(context, listen: true);
    return AlertDialog(
      // contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Expanded(
            flex: 9,
            child: Center(
              child: TextHeader1(
                title: 'Select State:'
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.close))
          ),
        ],
      ),
      shape: shape(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            onChanged: _filterItems,
            style: heading3TextStyle(width),
            decoration: InputDecoration(
              hintText: "Search...", hintStyle: heading3TextStyle(width)),
          ),
          Expanded(
            child: SizedBox(
              // height: height*0.,
              width: width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredItems!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    onTap: (){ 
                      appConstants.updateSelectedCounteryState(filteredItems![index]);
                      Navigator.pop(context, "Has");
                    },
                    title: Text('${filteredItems![index]}', style: heading3TextStyle(width*0.9)),
                  );
                },
              ),
            ),
          ),
        ],
      )
      );
    
  }
  }