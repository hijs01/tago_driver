import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  /// AppBar를 직접 지정 (없으면 null로 두면 됨)
  final PreferredSizeWidget? appBar;

  /// Scaffold 배경색
  final Color backgroundColor;

  /// 본문
  final Widget body;

  /// SafeArea 안쪽 padding
  final EdgeInsetsGeometry bodyPadding;

  /// body를 스크롤 가능하게 감쌀지 여부
  final bool scrollable;

  /// 하단 footer (선택)
  final Widget? footer;

  /// footer와 body 사이 간격
  final double footerSpacing;

  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    this.appBar,
    this.backgroundColor = Colors.black,
    required this.body,
    this.bodyPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.scrollable = false,
    this.footer,
    this.footerSpacing = 16.0,
    this.bottomNavigationBar
  });

  @override
  Widget build(BuildContext context) {
    // Body + Footer 구성
    Widget content = Padding(
      padding: bodyPadding,
      child: scrollable
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: body,
            )
          : body,
    );

    if (footer != null) {
      content = Padding(
        padding: bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: body,
                    )
                  : body,
            ),
            SizedBox(height: footerSpacing),
            Center(child: footer!),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea(child: content),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}