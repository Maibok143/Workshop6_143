import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final _firestore = FirebaseFirestore.instance;

  // ฟังก์ชันลบข้อมูล
  Future<void> deleteStudent(String documentId) async {
    await _firestore.collection('student').doc(documentId).delete();
  }

  // ฟังก์ชันแสดง Dialog ยืนยันการลบ
  Future<void> showDeleteConfirmation(String documentId) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบข้อมูล'),
          content: const Text('คุณต้องการลบข้อมูลจริง ๆ ใช่ไหมครับ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                await deleteStudent(documentId);
                Navigator.pop(context);
              },
              child: const Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันแสดง Dialog สำหรับแก้ไขข้อมูล (ข้อ 30)
  Future<void> showEditDialog(DocumentSnapshot document) async {
    final fnameController = TextEditingController(text: document['fname']);
    final lnameController = TextEditingController(text: document['lname']);
    final emailController = TextEditingController(text: document['email']);
    final scoreController = TextEditingController(text: document['score']);

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แก้ไขข้อมูลนักเรียน'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: fnameController, decoration: const InputDecoration(labelText: 'ชื่อ')),
                TextField(controller: lnameController, decoration: const InputDecoration(labelText: 'นามสกุล')),
                TextField(controller: emailController, decoration: const InputDecoration(labelText: 'อีเมล์')),
                TextField(controller: scoreController, decoration: const InputDecoration(labelText: 'คะแนน')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                await _firestore.collection('student').doc(document.id).update({
                  'fname': fnameController.text,
                  'lname': lnameController.text,
                  'email': emailController.text,
                  'score': scoreController.text,
                });
                Navigator.pop(context);
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายงานคะแนนสอบ"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 138, 224, 174),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("student").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];

              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: FittedBox(child: Text(document["score"])),
                ),
                title: Text("${document["fname"]} ${document["lname"]}"),
                subtitle: Text(document["email"]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ปุ่มแก้ไขข้อมูล (ไอคอนดินสอ)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => showEditDialog(document),
                    ),
                    // ปุ่มลบข้อมูล (ไอคอนถังขยะ)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async => await showDeleteConfirmation(document.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}