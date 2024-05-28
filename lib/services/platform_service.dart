import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformService {

  Widget buildCupertinoContextMenu(
      BuildContext context, Widget child, List<Widget> actions) {
    return CupertinoContextMenu(actions: actions, child: child);
  }

  void showContextMenu(BuildContext context, tapPosition,Function editFunction, Function deleteFunction) {
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            title: Text('ערוך'),
            leading: Icon(Icons.edit),
          ),
        ),
        const PopupMenuItem(
          value: 'favourite',
          child: ListTile(
            title: Text('הוסף למועדפים'),
            leading: Icon(Icons.favorite_border),
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            title: Text('מחק', style: TextStyle(color: Colors.red)),
            leading: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleMenuSelection(value, editFunction, deleteFunction);
      }
    });
  }

  void _handleMenuSelection(String value, Function editFunction, Function deleteFunction) {
    switch (value) {
      case 'edit':
        editFunction(String);
        break;
      case 'favourite':
        break;
      case 'delete':
        deleteFunction();
        break;
      default:
        break;
    }
  }
}