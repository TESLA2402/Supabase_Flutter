import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_supabase/services/auth.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Article extends StatefulWidget {
  final String articleUrl;
  const Article({required this.articleUrl});

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  WebViewController webViewController = WebViewController();
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "News",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                AuthService authService = AuthService();
                await authService.signOut();
              },
              padding: const EdgeInsets.symmetric(horizontal: 16),
              icon: const Icon(
                Icons.logout,
                size: 40,
              ))
        ],
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebViewWidget(
            controller: webViewController
              ..loadRequest(Uri.parse(widget.articleUrl))),
      ),
    );
  }
}
