import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/platform_service.dart';

class PlatformContextMenu extends StatefulWidget {
  const PlatformContextMenu(
      {super.key,required this.child, this.deleteFunction, this.editFunction});

  final Function()? deleteFunction;
  final Function()? editFunction;
  final Widget child;

  @override
  State<PlatformContextMenu> createState() => _PlatformContextMenuState();
}

final platformService = PlatformService();
late Offset _tapPosition;

class _PlatformContextMenuState extends State<PlatformContextMenu> {

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos
        ? platformService.buildCupertinoContextMenu(context, widget.child, [
      CupertinoContextMenuAction(
        trailingIcon: Icons.edit,
        child: const Text('ערוך'),
        onPressed: () {
          widget.editFunction!();
        },
      ),
      CupertinoContextMenuAction(
        isDestructiveAction: true,
        trailingIcon: Icons.delete,
        child: const Text('מחק'),
        onPressed: () {
          widget.deleteFunction!();
        },
      ),
    ])
        : GestureDetector(
      onLongPress: () {
         platformService.showContextMenu(context, _tapPosition, widget.editFunction!, widget.deleteFunction!);
      },
      onTapDown: (details) {
        _tapPosition = details.globalPosition;
      },
      child: widget.child,
    );
  }
}

