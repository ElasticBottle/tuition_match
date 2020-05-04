import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:flutter/material.dart';

enum LoadState {
  normal,
  loading,
  allLoaded,
}

class PaginatedSliverList<T> extends StatelessWidget {
  const PaginatedSliverList({
    Key key,
    @required this.displayItems,
    @required this.builder,
    this.loadState = LoadState.normal,
  })  : assert(displayItems != null),
        super(key: key);

  final List<T> displayItems;
  final Function(BuildContext context, T details) builder;
  final LoadState loadState;
  @override
  Widget build(BuildContext context) {
    return SliverList(
      ///Lazy building of list
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == displayItems.length) {
            switch (loadState) {
              case LoadState.normal:
                return EndTile();
                break;
              case LoadState.loading:
                return EndTile(loadState: LoadState.loading);
                break;
              case LoadState.allLoaded:
                return EndTile(loadState: LoadState.allLoaded);
                break;
            }
          }
          return builder(context, displayItems[index]);
        },
        childCount: displayItems.length + 1,
      ),
    );
  }
}

class EndTile extends StatelessWidget {
  const EndTile({this.loadState = LoadState.normal});
  final LoadState loadState;
  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (loadState) {
      case LoadState.normal:
        child = null;
        break;
      case LoadState.loading:
        child = Center(
          child: CircularProgressIndicator(),
        );
        break;
      case LoadState.allLoaded:
        child = Center(
          child: Text(
            Strings.allItemLoaded,
            style: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont,
            ),
          ),
        );
        break;
    }
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      child: child,
    );
  }
}
