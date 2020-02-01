/*
import 'package:flutter/material.dart';
import 'package:responsive_util/responsive_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Responsive'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Size _testMediaQuerySize;

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtil(
      onResize: (mediaQuerySize) {
        setState(() {
         _testMediaQuerySize = mediaQuerySize; 
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: GridView.count(
          /// This is a GridView that shrinks from 3 to 1 columns based on available width.
          /// 
          /// Because we are using a [ResponsiveUtil] to test, we replace the MediaQueries 
          /// with the size provided by [onResize] when available
          crossAxisCount: (_testMediaQuerySize?.width??MediaQuery.of(context).size.width) > 300 ? 3 : ((_testMediaQuerySize?.width??MediaQuery.of(context).size.width) > 180 ? 2 : 1),
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline,
              ),
            );
          }),
        ),
      ),
    );
  }
}
*/