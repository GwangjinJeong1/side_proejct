import 'dart:ui_web' as ui;
import 'dart:html';

import 'package:flutter/material.dart';

class AdWidget extends StatefulWidget {
  const AdWidget({super.key});

  @override
  _AdWidgetState createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  final String viewType = 'ad-iframe';

  @override
  void initState() {
    super.initState();

    ui.platformViewRegistry.registerViewFactory(
        viewType,
        (int viewID) => IFrameElement()
          ..width = '500'
          ..height = '100'
          ..src = 'adview.html'
          ..style.border = 'none');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: 500.0,
      child: HtmlElementView(
        viewType: viewType,
      ),
    );
  }
}
