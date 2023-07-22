import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class termsAndCondWebView extends StatefulWidget {
  const termsAndCondWebView({super.key});

  @override
  State<termsAndCondWebView> createState() => _termsAndCondWebViewState();
}

class _termsAndCondWebViewState extends State<termsAndCondWebView> {
  late final WebViewController _controller;

  void WebControl() {
    String url = "https://docs.flutter.dev/tos";
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
        title: Text("Terms and Conditions"),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
