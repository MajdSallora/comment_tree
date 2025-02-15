import 'package:flutter/material.dart';
import './comment_child_widget.dart';
import './root_comment_widget.dart';
import './tree_theme_data.dart';
import 'package:provider/provider.dart';

typedef AvatarWidgetBuilder<T> = PreferredSize Function(
  BuildContext context,
  T value,
);
typedef ContentBuilder<T> = Widget Function(BuildContext context, T value);

class CommentTreeWidget<R, C> extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = 'CommentTreeWidget';

  final R root;
  final List<C> replies;

  final AvatarWidgetBuilder<R>? avatarRoot;
  final ContentBuilder<R>? contentRoot;

  final AvatarWidgetBuilder<C>? avatarChild;
  final ContentBuilder<C>? contentChild;
  final TreeThemeData treeThemeData;

  const CommentTreeWidget(
    this.root,
    this.replies, {
    this.treeThemeData = const TreeThemeData(lineWidth: 1),
    this.avatarRoot,
    this.contentRoot,
    this.avatarChild,
    this.contentChild,
  });

  @override
  _CommentTreeWidgetState<R, C> createState() => _CommentTreeWidgetState<R, C>();
}

class _CommentTreeWidgetState<R, C> extends State<CommentTreeWidget<R, C>> {
  @override
  Widget build(BuildContext context) {
    final PreferredSize avatarRoot = widget.avatarRoot!(context, widget.root);
    return Provider<TreeThemeData>.value(
      value: widget.treeThemeData,
      child: Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              childrenPadding: EdgeInsets.zero,
              tilePadding: EdgeInsets.only(
                  left: Directionality.of(context) == TextDirection.rtl? 10: 0,
                  right: Directionality.of(context) == TextDirection.ltr? 10: 0,
              ),
              title: RootCommentWidget(
                avatarRoot,
                widget.contentRoot!(context, widget.root),
              ),
              children: [
                ...widget.replies.map(
                  (e) => CommentChildWidget(
                    isLast: widget.replies.indexOf(e) == (widget.replies.length - 1),
                    avatar: widget.avatarChild!(context, e),
                    avatarRoot: avatarRoot.preferredSize,
                    content: widget.contentChild!(context, e),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
