import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cotor/common_widgets/information_capture/multi_filter_select/Item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MultiFilterSelectPage extends StatefulWidget {
  const MultiFilterSelectPage({
    this.placeholder,
    @required this.allItems,
    @required this.initValue,
    this.isSingleSelect,
  });
  final String placeholder;
  final List<Item> allItems;
  final List initValue;
  final bool isSingleSelect;

  @override
  State<StatefulWidget> createState() => MultiFilterSelectPageState();
}

class MultiFilterSelectPageState extends State<MultiFilterSelectPage> {
  List<Item> filterItemList;
  List selectedItemValueList;

  @override
  void initState() {
    super.initState();
    selectedItemValueList = widget.initValue;
    filterItemList = widget.allItems;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              10, 10, 10, MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                actions: [
                  IconButton(
                    icon: Transform.rotate(
                      alignment: Alignment.center,
                      angle: math.pi / 2 * 3,
                      child: Icon(Icons.arrow_back_ios,
                          color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () =>
                        Navigator.pop(context, selectedItemValueList),
                  ),
                ],
                title: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 33, maxWidth: 280),
                  child: TextField(
                    onChanged: (text) {
                      filterItemList = widget.allItems
                          .where((item) =>
                              item.display
                                  .toString()
                                  .toLowerCase()
                                  .contains(text.toLowerCase()) ||
                              item.content
                                  .toString()
                                  .toLowerCase()
                                  .contains(text.toLowerCase()))
                          .toList();
                      setState(() {});
                    },
                    autofocus: false,
                    onSubmitted: (_) {
                      Navigator.pop(context, selectedItemValueList);
                    },
                    style: TextStyle(fontSize: 14),
                    cursorColor: Colors.grey,
                    cursorWidth: 1.5,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 0, bottom: 0, left: 10),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                        suffixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none),
                        hintText: widget.placeholder ?? 'search……'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              widget.isSingleSelect
                  ? _singleSelectItems(context)
                  : _multiSelectItems(context),
            ],
          ),
        ),
      ),
      onWillPop: () {
        Navigator.pop(context, selectedItemValueList);
        return Future.value(false);
      },
    );
  }

  Widget _singleSelectItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...filterItemList.map((item) {
          final bool _selected = selectedItemValueList.contains(item.value);
          return GestureDetector(
            onTap: () {
              if (_selected) {
                selectedItemValueList.remove(item.value);
              } else {
                selectedItemValueList.clear();
                selectedItemValueList.add(item.value);
              }
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      item.content,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  if (_selected)
                    Expanded(
                      flex: 1,
                      child: FaIcon(FontAwesomeIcons.solidDotCircle),
                    ),
                  if (!_selected)
                    Expanded(
                      flex: 1,
                      child: FaIcon(FontAwesomeIcons.circle),
                    )
                ],
              ),
            ),
          );
        }).toList()
      ],
    );
  }

  Widget _multiSelectItems(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: filterItemList.map(
        (item) {
          final bool _selected = selectedItemValueList.contains(item.value);
          return GestureDetector(
            onTap: () {
              if (_selected) {
                selectedItemValueList.remove(item.value);
              } else {
                selectedItemValueList.add(item.value);
              }
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Text(
                item.content,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              decoration: BoxDecoration(
                color: _selected
                    ? Theme.of(context).colorScheme.primaryVariant
                    : Theme.of(context).colorScheme.surface,
                border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: _selected ? Colors.blue[200] : Colors.black12),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
