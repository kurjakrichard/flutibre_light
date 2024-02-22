import 'package:flutibre_light/providers/booklist_provider.dart';
import 'package:flutibre_light/screens/show_items_screen.dart';
import 'package:flutibre_light/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/manage_item_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Flutibre());
}

class Flutibre extends StatelessWidget {
  const Flutibre({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => BooksProvider())],
      builder: (context, child) => MaterialApp(
        theme: baseTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const ShowItemsScreen(),
          '/addpage': (context) => const ManageItemScreen(
                title: 'Add Item',
                buttonText: 'Insert',
              ),
          '/editpage': (context) => const ManageItemScreen(
                title: 'Edit Item',
                buttonText: 'Update',
              )
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutibre',
      ),
    );
  }
}
