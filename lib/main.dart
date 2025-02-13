import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/login.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://zbfhhlevlgmcmnkuqtzj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpiZmhobGV2bGdtY21ua3VxdHpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MTEwMzksImV4cCI6MjA1NDk4NzAzOX0.5Hag05MNbfjHOmpq1O7O57vT_0poXS5Etm_vttd6Dwk',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  LoginPage(),
    );
  }
}
