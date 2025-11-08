import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Widget body;
  final EdgeInsetsGeometry bodyPadding;
  final bool scrollable;
  final Widget? footer;
  final double footerSpacing;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    this.appBar,
    this.backgroundColor,
    this.endDrawer,
    this.backgroundGradient,
    required this.body,
    this.bodyPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.scrollable = false,
    this.footer,
    this.footerSpacing = 16.0,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    // StatusBar 스타일 설정 (그라디언트 사용 시)
    if (backgroundGradient != null) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    }

    Widget content = Padding(
      padding: bodyPadding,
      child:
          scrollable
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
              child:
                  scrollable
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

    // ===== 🔥 그라디언트 사용 시 완전히 다른 구조 =====
    if (backgroundGradient != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: appBar,
        endDrawer: endDrawer,
        body: Container(
          // 그라디언트를 최상단에 배치
          decoration: BoxDecoration(gradient: backgroundGradient),
          // SafeArea는 그라디언트 안쪽에
          child: SafeArea(
            // ===== 🔥 top: false로 StatusBar 영역까지 사용 =====
            top: false,
            child: content,
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      );
    }

    // ===== 단색 배경 사용 시 기존 방식 =====
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.black,
      appBar: appBar,
      endDrawer: endDrawer,
      extendBody: true,
      body: SafeArea(child: content),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
