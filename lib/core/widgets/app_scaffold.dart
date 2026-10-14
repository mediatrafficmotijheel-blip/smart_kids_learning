import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.bottomNavigationBar,
  });

  final String? title;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null ? null : AppBar(title: Text(title!)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 600 ? 32.0 : 16.0;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: body,
            );
          },
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}