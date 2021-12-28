import 'package:flutter/material.dart';
import 'package:responsive_util/responsive_util.dart';

void main() => runApp(const MaterialApp(home: TestApp()));

class TestApp extends StatefulWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  late Size? deviceSize;
  Size? _utilSize;

  int columnCount() {
    if (deviceSize == null) {
      return 0;
    }

    if ((_utilSize?.width ?? deviceSize!.width) > 300) {
      return 3;
    } else if ((_utilSize?.width ?? deviceSize!.width) > 180) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return ResponsiveUtil(
      onResize: (resize) {
        setState(() {
          _utilSize = resize;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Responsive Test'),
        ),
        body: GridView.count(
          /// This is a GridView that shrinks from 3 to 1 columns based on available width.
          crossAxisCount: columnCount(),
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
              ),
            );
          }),
        ),
      ),
    );
  }
}
