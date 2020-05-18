import 'package:flutter/material.dart';

class Item<V, D, C> {
  Item.build({
    @required this.value,
    @required this.display,
    @required this.content,
  });
  Item.fromJson(
    Map<String, dynamic> json, {
    String displayKey = 'display',
    String valueKey = 'value',
    String contentKey = 'content',
  })  : value = json[valueKey] ?? '',
        display = json[displayKey] ?? '',
        content = json[contentKey] ?? '';
  V value;

  /// display in the TextField
  D display;

  /// display in the list content.
  C content;

  static List<Item> allFromJson(
    List jsonList, {
    String displayKey = 'display',
    String valueKey = 'value',
    String contentKey = 'content',
  }) {
    return jsonList
        .map((dynamic json) => Item<dynamic, dynamic, dynamic>.fromJson(
              json,
              displayKey: displayKey,
              valueKey: valueKey,
              contentKey: contentKey,
            ))
        .toList();
  }
}
