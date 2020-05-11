import 'package:cotor/constants/strings.dart';
import 'package:flutter/material.dart';

enum LoadState {
  normal,
  loading,
  allLoaded,
  customMessage,
}

class PaginatedSliverList extends StatelessWidget {
  const PaginatedSliverList({
    Key key,
    @required this.displayItems,
    @required this.builder,
    this.loadState = LoadState.normal,
    this.endMsg = '',
  })  : assert(displayItems != null),
        assert(builder != null),
        super(key: key);

  final List displayItems;
  final Function(BuildContext context, dynamic details) builder;
  final LoadState loadState;
  final String endMsg;
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
              case LoadState.customMessage:
                return EndTile(
                  loadState: LoadState.customMessage,
                  endMsg: endMsg,
                );
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
  const EndTile({
    this.loadState = LoadState.normal,
    this.endMsg = '',
  });
  final LoadState loadState;
  final String endMsg;
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
            // style: TextStyle(
            //   color: ColorsAndFonts.primaryColor,
            //   fontFamily: ColorsAndFonts.primaryFont,
            // ),
          ),
        );
        break;
      case LoadState.customMessage:
        child = Center(
          child: Text(
            endMsg,
            style: Theme.of(context).textTheme.bodyText1,
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
