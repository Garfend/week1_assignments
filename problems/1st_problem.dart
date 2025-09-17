
import 'package:flutter/cupertino.dart';

abstract class ContentItem {
  Widget build(BuildContext context);
}

class TextItem extends ContentItem {
  final String text;

  TextItem(this.text);

  @override
  Widget build(BuildContext context) => Text(text);
}

class ImageItem extends ContentItem {
  final String url;

  ImageItem(this.url);

  @override
  Widget build(BuildContext context) => Image.network(url);
}

class ContentDisplay extends StatelessWidget {
  final List<ContentItem> items;

  const ContentDisplay(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: items.map((item) => item.build(context)).toList());
  }
}
