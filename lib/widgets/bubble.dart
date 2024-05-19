import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class Bubble extends StatefulWidget {
  const Bubble(
      {super.key,
      required this.date,
      required this.text,
      this.deleteFunction,
      this.editFunction});

  final String date;
  final String text;
  final Function()? deleteFunction;
  final Function()? editFunction;

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  late Offset _tapPosition;

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomText(
            fontSize: 12,
            color: colorScheme.onSurface,
            text: widget.date,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 5,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: isIos
                ? buildCupertinoContextMenu(context, _buildBubble(context), [
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
                      _showContextMenu(context);
                    },
                    onTapDown: (details) {
                      _tapPosition = details.globalPosition;
                    },
                    child: _buildBubble(context),
                  ),
          )
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        _tapPosition & const Size(40, 40),
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
        _handleMenuSelection(value);
      }
    });
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        widget.editFunction!();
        break;
      case 'favourite':
        break;
      case 'delete':
        widget.deleteFunction!();
        break;
      default:
        break;
    }
  }

  Widget buildCupertinoContextMenu(
      BuildContext context, Widget child, List<Widget> actions) {
    return CupertinoContextMenu(actions: actions, child: child);
  }

  Widget _buildBubble(context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: isDark ? greyShade400 : greyShade100,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: CustomText(
          fontSize: 16,
          color: colorScheme.onSurface,
          text: widget.text,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
