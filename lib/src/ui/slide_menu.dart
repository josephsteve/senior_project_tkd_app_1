import 'dart:async';
import 'package:flutter/material.dart';

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;
  final Stream triggerCloseMenu;

  SlideMenu({this.child, this.menuItems, this.triggerCloseMenu});
  @override
  _SlideMenuState createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
  StreamSubscription streamSubscription;
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    streamSubscription = widget.triggerCloseMenu.listen((_) => closeMenu());
  }

  @override
  didUpdateWidget(SlideMenu old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.triggerCloseMenu != old.triggerCloseMenu) {
      streamSubscription.cancel();
      streamSubscription = widget.triggerCloseMenu.listen((_) => closeMenu());
    }
  }

  @override
  dispose() {
    _controller.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  closeMenu() {
    _controller.animateTo(.0);
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.2, 0.0)
    ).animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller.animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 || data.primaryVelocity < -2500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
//                            color: Colors.black26,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}