# Usage
Resize the entire screen's layout.
```
  @override
  Widget build(BuildContext context) {
    return ResponsiveUtil(
      child: Scaffold(
        body: Container()
      ),
    );
  }
}
```
Resize a Widget, this example switches between using a Column and Row depending on available width.
```
ResponsiveUtil(
  child: Card(
    child: LayoutBuilder(builder: (context, constraints) {
      Axis direction = constraints.maxWidth > 300
          ? Axis.horizontal
          : Axis.vertical;
      return Flex(
        // if wrapper width < 300, use a column rather than a Row
        direction: direction,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(12.0),
            child: CircleAvatar(
              radius: 32,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
              ),
            ),
          ),
        ],
      );
    }),
  ),
)
```
Resize a Widget in a ScrollView by passing a ScrollController.
```
Card(
  // containers with margins should wrap RespsoniveUtil 
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  child: ResponsiveUtil(
    scrollController: scrollController,
    child: LayoutBuilder(builder: (context, constraints) {
      Axis direction = constraints.maxWidth > 300
          ? Axis.horizontal
          : Axis.vertical;
      return Flex(
        direction: direction,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(12.0),
            child: CircleAvatar(
              radius: 32,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: AutoSizeText(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                minFontSize: direction ==Axis.horizontal ? 14 :  8,
              style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      );
    }),
  ),
)
```