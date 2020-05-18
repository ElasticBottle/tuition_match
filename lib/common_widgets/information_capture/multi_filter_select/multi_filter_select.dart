import 'package:cotor/common_widgets/information_capture/multi_filter_select/multi_filter_select_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cotor/common_widgets/information_capture/multi_filter_select/Item.dart';

typedef SelectCallback = Function(List selectedValue);

class MultiFilterSelect extends StatefulWidget {
  const MultiFilterSelect({
    this.height,
    this.labelText = '',
    this.errorText,
    this.hintText,
    this.fontSize,
    this.tail,
    @required this.allItems,
    this.initValue,
    @required this.selectCallback,
    this.disabled = false,
    this.isSingleSelect = false,
  });
  final double height;
  final String labelText;
  final String errorText;
  final String hintText;
  final double fontSize;
  final Widget tail;
  final List<Item<dynamic, dynamic, dynamic>> allItems;
  final List initValue;
  final SelectCallback selectCallback;
  final bool disabled;
  final bool isSingleSelect;

  @override
  State<StatefulWidget> createState() => MultiFilterSelectState();
}

class MultiFilterSelectState extends State<MultiFilterSelect> {
  List _selectedValue = <dynamic>[];

  @override
  Widget build(BuildContext context) {
    if (widget.initValue == null) {
      _selectedValue = <dynamic>[];
    } else {
      _selectedValue = widget.initValue;
    }
    return Opacity(
      opacity: widget.disabled ? 0.4 : 1,
      child: GestureDetector(
        onTap: () async {
          if (!widget.disabled) {
            _selectedValue = await showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    15.0,
                  ),
                ),
              ),
              context: context,
              builder: (BuildContext context) {
                return MultiFilterSelectPage(
                  allItems: widget.allItems,
                  initValue: widget.initValue ?? <dynamic>[],
                  isSingleSelect: widget.isSingleSelect,
                );
              },
            );
            // _selectedValue = await Navigator.of(context).push(MaterialPageRoute(
            //     builder: (_) => MultiFilterSelectPage(
            //           allItems: widget.allItems,
            //           initValue: widget.initValue ?? <dynamic>[],
            //         )));
            setState(() {});
            widget.selectCallback(_selectedValue);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText.isNotEmpty)
              Text(
                widget.labelText,
                style: Theme.of(context).textTheme.headline6,
              ),
            _selectedValue.isNotEmpty
                ? _getValueWrp(context)
                : _getEmptyWrp(context),
            if (widget.errorText != null) SizedBox(height: 10.0),
            if (widget.errorText != null)
              Text(
                widget.errorText,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getEmptyWrp(BuildContext context) {
    return Container(
      height: widget.height ?? 60,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              widget.hintText ?? '',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          widget.tail ??
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.5),
                child: Icon(Icons.menu, color: Colors.black54, size: 25),
              ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _getValueWrp(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Wrap(
        spacing: 5.0,
        runSpacing: 5.0,
        children: widget.allItems
            .where((item) => _selectedValue.contains(item.value))
            .map((item) => RawChip(
                  label: Text(
                    item.display,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .apply(fontSizeDelta: -3),
                  ),
                  isEnabled: !widget.disabled,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  deleteIconColor: Theme.of(context).textTheme.button.color,
                  onDeleted: () {
                    if (!widget.disabled) {
                      _selectedValue.remove(item.value);
                      widget.selectCallback(_selectedValue);
                      setState(() {});
                    }
                  },
                ))
            .toList(),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
