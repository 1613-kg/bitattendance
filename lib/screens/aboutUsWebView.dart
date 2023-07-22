import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class aboutUsWebView extends StatefulWidget {
  const aboutUsWebView({super.key});

  @override
  State<aboutUsWebView> createState() => _aboutUsWebViewState();
}

class _aboutUsWebViewState extends State<aboutUsWebView> {
  late final WebViewController _controller;

  void WebControl() {
    String url = "https://docs.flutter.dev/resources/faq";
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (navigation) {
            if (navigation.url != url) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WebControl();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    WebControl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About us"),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
