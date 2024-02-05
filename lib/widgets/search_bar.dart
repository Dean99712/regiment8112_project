import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/filter_provider.dart';
import '../providers/search_provider.dart';
import '../utils/colors.dart';

class CustomSearchBar extends ConsumerStatefulWidget {
  const CustomSearchBar({required this.controller, this.onChanged, super.key});

  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  ConsumerState<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends ConsumerState<CustomSearchBar> {
  double _elevation = 0.0;
  double _radius = 10.0;

  @override
  Widget build(BuildContext context) {

    final FocusNode focus = FocusNode();
    var isGrouped = ref.watch(isGroupedProvider);

    return WillPopScope(
      onWillPop: () async {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        return false;
      },
      child: Focus(
        onFocusChange: (focused) {
          setState(() {
            _elevation = focused ? 0 : 2;
            _radius = focused ? 30.0 : 10.0;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 45,
                  child: PlatformSearchField(
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    focusNode: focus,
                    radius: _radius,
                    elevation: _elevation,
                  ),
                ),
                IconButton(
                  color: primaryColor,
                  enableFeedback: true,
                  icon: const Icon(Icons.filter_list_outlined),
                  onPressed: () {
                    ref.read(isGroupedProvider.notifier).state = !isGrouped;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlatformSearchField extends ConsumerWidget {
  const PlatformSearchField(
      {required this.controller,
      this.onChanged,
      required this.focusNode,
      this.radius,
      this.elevation,
      super.key});

  final TextEditingController controller;
  final void Function(String)? onChanged;
  final FocusNode focusNode;
  final double? elevation;
  final double? radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var search = ref.watch(searchProvider);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 1.35,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: CupertinoSearchTextField(
            onChanged: onChanged,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            backgroundColor: isDark ? white.withOpacity(0.3) : greyShade100,
            placeholder: "חפש...",
          ),
        ),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SearchBar(
          focusNode: focusNode,
          controller: controller,
          trailing: <Widget>[
            search.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.close,
                      color: colorScheme.onBackground,
                    ),
                    onPressed: () {
                      controller.clear();
                      ref.read(searchProvider.notifier).state = '';
                    })
                : const SizedBox()
          ],
          onChanged: onChanged,
          backgroundColor: MaterialStateProperty.all(isDark
              ? colorScheme.onBackground.withOpacity(0.5)
              : greyShade10),
          leading: Icon(
            Icons.search,
            color: Colors.transparent.withOpacity(0.4),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.3,
          ),
          elevation: MaterialStateProperty.all(elevation),
          textStyle: MaterialStateProperty.all(GoogleFonts.heebo()),
          hintText: 'חפש...',
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(radius!),
            )),
          ),
        ),
      );
    }
  }
}
