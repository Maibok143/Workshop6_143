import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/formscreen.dart';
import 'screen/displayscreen.dart'; // Import หน้า DisplayScreen เข้ามาใช้งาน

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // กำหนดจำนวนหน้าแท็บเป็น 2 หน้า
      child: Scaffold(
        body: const TabBarView(
          children: [
            FormScreen(),    // แท็บแรก: หน้าบันทึกฟอร์ม
            DisplayScreen(), // แท็บสอง: หน้าแสดงรายงาน
          ],
        ),
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 49, 224, 157),
          child: const TabBar(
            tabs: [
              Tab(text: "บันทึกคะแนน", icon: Icon(Icons.add)),
              Tab(text: "รายงานคะแนน", icon: Icon(Icons.list)),
            ],
          ),
        ),
      ),
    );
  }
}