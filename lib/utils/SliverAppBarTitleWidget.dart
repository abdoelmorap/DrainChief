// Flutter imports:
import 'package:flutter/material.dart';

class SliverAppBarTitleWidget extends StatefulWidget {
  final Widget? child;

  const SliverAppBarTitleWidget({
    Key? key,
    @required this.child,
  }) : super(key: key);

  @override
  _SliverAppBarTitileWidgetState createState() {
    return new _SliverAppBarTitileWidgetState();
  }
}

class _SliverAppBarTitileWidgetState extends State<SliverAppBarTitleWidget> {
  ScrollPosition? _position;
  bool? _visible;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)!.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
    context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return AnimatedOpacity(
    //     // If the widget is visible, animate to 0.0 (invisible).
    //     // If the widget is hidden, animate to 1.0 (fully visible).
    //     opacity: _visible ? 1.0 : 0.0,
    //     duration: const Duration(milliseconds: 100),
    //     child: widget.child);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      child: Visibility(
        visible: _visible ?? false,
        child: widget.child!,
      ),
    );
  }
}
