import 'package:flutter/material.dart';

class AssignmentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        ///First sliver is the App Bar
        CustomSliverAppbar(),
        SliverList(
          ///Lazy building of list
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              /// To convert this infinite list to a list with "n" no of items,
              /// uncomment the following line:
              /// if (index > n) return null;
              return listItem(Colors.yellow[600], 'Sliver List item: $index');
            },
          ),
        )
      ],
    );
  }

  Widget listItem(Color color, String title) => Container(
        height: 100.0,
        color: color,
        child: Center(
          child: Text(
            '$title',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand'),
          ),
        ),
      );
}

class CustomSliverAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      ///Properties of app bar
      backgroundColor: Colors.white,
      elevation: 10,
      primary: true,
      floating: true,
      snap: false,
      pinned: false,
      centerTitle: false,
      title: Text(
        'Assginments',
        style: TextStyle(
            color: Colors.black87,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand'),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {
            print('search press');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.black,
          ),
          onPressed: () {
            print('favourtie press');
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.0),
        )
      ],
    );
  }
}
