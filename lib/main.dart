import 'package:flutibre_light/screens/home_screen.dart';
import 'package:flutibre_light/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/edit_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: Flutibre()));
}

class Flutibre extends StatelessWidget {
  const Flutibre({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: baseTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/addpage': (context) => const EditScreen(
              title: 'Add Item',
              buttonText: 'Insert',
            ),
        '/editpage': (context) => const EditScreen(
              title: 'Edit Item',
              buttonText: 'Update',
            )
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutibre',
    );
  }
}
