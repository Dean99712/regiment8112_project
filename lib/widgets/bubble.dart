import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:regiment8112/widgets/platform_context_menu.dart';
import '../services/platform_service.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class Bubble extends StatefulWidget {
  Bubble(
      {super.key,
      required this.date,
      required this.text,
      required this.id,
      this.textEditingController,
      this.editingId,
      this.onEdit,
      this.initialMessage,
      this.deleteFunction,
      this.editFunction});

  final String date;
  final String text;
  final String id;
  late String? editingId;
  final String? initialMessage;
  final Function()? deleteFunction;
  final Function(String)? onEdit;
  final Future<void> Function(String id)? editFunction;
  late TextEditingController? textEditingController;

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  late Offset _tapPosition;
  final platformService = PlatformService();
  String currentText = '';

  @override
  void initState() {
    super.initState();
    widget.textEditingController =
        TextEditingController(text: widget.initialMessage);
  }



  Future<void> _updateMessage() async {
    await widget.editFunction!(widget.textEditingController!.text);
    setState(() {
      // currentText = widget.textEditingController!.text;
      widget.onEdit!('');  // Exit edit mode
    });
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
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
                ? PlatformContextMenu(
                    deleteFunction: widget.deleteFunction,
                    editFunction: () => widget.editFunction!(widget.id),
                    child: widget.editingId == widget.id
                        ? _buildEditBubble(context)
                        : _buildBubble(context))
                : GestureDetector(
                    onLongPress: () {
                      platformService.showContextMenu(context, _tapPosition,
                          widget.editFunction!, widget.deleteFunction!);
                    },
                    onTapDown: (details) {
                      _tapPosition = details.globalPosition;
                    },
                    child: widget.editingId == widget.id ? _buildEditBubble(context) : _buildBubble(context),
                  ),
          )
        ]));
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
            borderRadius: const BorderRadius.all(Radius.circular(25))),
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

  Widget _buildEditBubble(context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PlatformTextField(
      controller: widget.textEditingController,
      keyboardType: TextInputType.text,
      autofocus: true,
      onChanged: (value) {
        widget.textEditingController!.text = value;
      },
      material: (context, platform) {
        return MaterialTextFieldData(
          decoration: InputDecoration(
              filled: true,
              prefix: GestureDetector(
                onTap: _updateMessage,
                child: Icon(
                  Icons.send,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: colorScheme.primary))),
            style: TextStyle(color: colorScheme.onSurface));
      },
      cupertino: (context, platform) {
        return CupertinoTextFieldData(
            autocorrect: true,
            decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: colorScheme.primary)),
            prefix: GestureDetector(
              onTap: _updateMessage,
              child: Icon(
                CupertinoIcons.arrow_up_circle_fill,
                color: colorScheme.primary,
                size: 30,
              ),
            ),
            style: TextStyle(color: colorScheme.onSurface));
      },
    );
  }
}
