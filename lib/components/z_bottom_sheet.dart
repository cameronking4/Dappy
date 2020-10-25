import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Null OnValueChangeCallBack(String value);
typedef Null OnIndexChangeCallBack(int value);

class ZBottomSheet extends StatefulWidget {
  final List<ZBottomSheetItem> zbottomSheetItems;
  final MainAxisAlignment mainAxisAlignment;
  final OnIndexChangeCallBack onIndexChanged;
  final OnValueChangeCallBack onValueChanged;
  final Widget child;
  final bool isDismissible;
  final bool isEnabled;
  final bool showDivider;

  ZBottomSheet({
    Key key,
    @required this.child,
    @required this.onValueChanged,
    this.onIndexChanged,
    this.zbottomSheetItems,
    this.isEnabled = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.showDivider = true,
    this.isDismissible = true,
  }) : super(key: key);

  _ZBottomSheetState createState() => _ZBottomSheetState();
}

class _ZBottomSheetState extends State<ZBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showModalBottomSheet(context: context);
      },
      child: widget.child,
    );
  }

  void _showModalBottomSheet({context}) {
    showModalBottomSheet(
        isDismissible: widget.isDismissible,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Scrollbar(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  children: [
                    if (widget.zbottomSheetItems != null) Divider(height: 0),
                    for (var item in widget.zbottomSheetItems)
                      Column(
                        key: ObjectKey(item),
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  widget.zbottomSheetItems.indexOf(item) == 0
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))
                                      : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: widget.mainAxisAlignment,
                                  children: <Widget>[
                                    if (item.icon != null)
                                      Row(
                                        children: <Widget>[
                                          item.icon,
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    item.text,
                                  ],
                                ),
                              ),
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                widget.onValueChanged(item.text.data);
                                if (widget.onIndexChanged != null &&
                                    widget.zbottomSheetItems.indexOf(item) !=
                                        null) {
                                  widget.onIndexChanged(
                                      widget.zbottomSheetItems.indexOf(item));
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          if (widget.showDivider) Divider(height: 0)
                        ],
                      ),
                    SizedBox(
                      height: 35,
                    )
                  ]),
            ),
          );
        });
  }
}

class ZBottomSheetItem {
  Text text;
  Icon icon;
  TextStyle textStyle;

  ZBottomSheetItem({
    this.icon,
    @required this.text,
  });
}
