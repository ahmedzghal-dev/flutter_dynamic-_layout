// import 'package:flutter/material.dart';
// import 'package:flutter_dynamic_layout/provider/layout_provider.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final layoutProvider = LayoutProvider.instance;

//     return ChangeNotifierProvider.value(
//       value: layoutProvider,
//       child: Consumer<LayoutProvider>(
//         builder: (context, provider, _) {
//           bool isAppBarVisible = provider.getComponentVisibility("showAppBar");
//           return Scaffold(
//             appBar: isAppBarVisible
//                 ? AppBar(
//                     title: Align(
//                       alignment: provider.appBarTitleAlignment,
//                       child: Text("Dynamic Layout"),
//                     ),
//                   )
//                 : null,
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       provider.toggleComponentVisibility("showAppBar");
//                     },
//                     child:
//                         Text(isAppBarVisible ? "Hide App Bar" : "Show App Bar"),
//                   ),
//                   ElevatedButton(
//                     onPressed: provider.toggleAppBarTitleAlignment,
//                     child: const Text("Toggle App Bar Title Alignment"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_layout/provider/layout_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Accessing LayoutProvider to get current layout settings
    final layoutProvider = Provider.of<LayoutProvider>(context);

    // AppBar configuration
    bool appBarVisible =
        layoutProvider.isVisible('appBar.visible', defaultValue: true);
    String appBarTitleAlignment = layoutProvider
        .getSetting('appBar.titleAlignment', defaultValue: 'left');

    // Product List configuration
    bool productListVisible =
        layoutProvider.isVisible('productList.visible', defaultValue: true);
    String productListLayout =
        layoutProvider.getSetting('productList.layout', defaultValue: 'list');
    int productColumns =
        layoutProvider.getSetting('productList.columns', defaultValue: 2);

    // Cart Button configuration
    bool cartButtonVisible =
        layoutProvider.isVisible('cartButton.visible', defaultValue: true);
    String cartButtonPosition = layoutProvider.getSetting('cartButton.position',
        defaultValue: 'bottomRight');

    return Scaffold(
      appBar: appBarVisible
          ? AppBar(
              title: Align(
                alignment: appBarTitleAlignment == 'center'
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: Text('Home'),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Toggle buttons for layout settings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Toggle visibility of the AppBar
                    bool currentVisibility = layoutProvider
                        .isVisible('appBar.visible', defaultValue: true);
                    layoutProvider.updateSetting(
                        'appBar.visible', !currentVisibility);
                  },
                  child: Text('Toggle AppBar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Toggle alignment of the AppBar title
                    String newAlignment =
                        appBarTitleAlignment == 'center' ? 'left' : 'center';
                    layoutProvider.updateSetting(
                        'appBar.titleAlignment', newAlignment);
                  },
                  child: Text('Toggle AppBar Alignment'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Toggle visibility of the product list
                    bool currentVisibility = layoutProvider
                        .isVisible('productList.visible', defaultValue: true);
                    layoutProvider.updateSetting(
                        'productList.visible', !currentVisibility);
                  },
                  child: Text('Toggle Product List'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Toggle product list layout between grid and list
                    String newLayout =
                        productListLayout == 'grid' ? 'list' : 'grid';
                    layoutProvider.updateSetting(
                        'productList.layout', newLayout);
                  },
                  child: Text('Toggle Product Layout'),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (productListVisible)
              Expanded(
                child: productListLayout == 'grid'
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: productColumns,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: 20, // Number of products
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4.0,
                            child: Center(
                              child: Text('Product $index'),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.shopping_cart),
                            title: Text('Product $index'),
                          );
                        },
                      ),
              ),
            if (cartButtonVisible)
              Align(
                alignment: cartButtonPosition == 'bottomRight'
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                child: FloatingActionButton(
                  onPressed: () {
                    // Cart button action
                  },
                  child: Icon(Icons.shopping_cart),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
