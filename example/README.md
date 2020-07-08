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
```
Or use the builder function to directly pass updated constraints without needing a separate `LayoutBuilder`
```
ResponsiveUtil(
  builder: (context, constraints) {
    // if width < 300, use a column rather than a Row
    Axis direction =
        constraints.maxWidth > 300 ? Axis.horizontal : Axis.vertical;
    return Card(
      child: Flex(
        direction: direction,
        children: <Widget>[
          // ....
        ],
      ),
    );
  },
)
```
If the Widget to resize is in some ScrollView, also pass in the a ScrollController.
```
SingleChildScrollView(
  controller: _scrollController,
  child: ResponsiveUtil(
    scrollController: _scrollController,
    builder: (context, constraints) {
      // if width < 300, use a column rather than a Row
      Axis direction =
          constraints.maxWidth > 300 ? Axis.horizontal : Axis.vertical;
      return Card(
        child: Flex(
          direction: direction,
          children: <Widget>[
            // ....
          ],
        ),
      );
    },
  ),
)
```