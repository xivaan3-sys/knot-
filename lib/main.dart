import 'package:flutter/material.dart';

// 1. نقطة البداية الأساسية لتشغيل التطبيق (تصلح خطأ No 'main' method found)
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سوق السلع المعمدة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // ثيم مظلم يتناسب مع ألوان تطبيقك
      home: const MainSectionsScreen(userPhone: '0500000000'), // شاشة البداية مع رقم هاتف افتراضي
    );
  }
}

// --- الشاشة الرئيسية للسوق وعرض السلع المعمدة ---
class MainSectionsScreen extends StatelessWidget {
  final String userPhone;
  const MainSectionsScreen({super.key, required this.userPhone});

  // كود تحقق بسيط من هوية المشرف قبل الدخول للوحة التحكم لحماية البيانات
  void _promptAdminAccess(BuildContext context) {
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFFFD700), width: 1),
        ),
        title: const Text(
          'طلب إذن الدخول للإدارة',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFFFD700), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 6),
          decoration: const InputDecoration(
            hintText: 'رمز PIN الخاص بالمشرف',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 13, letterSpacing: 0),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFD700))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // الرمز الافتراضي للدخول هو 1234
              if (pinController.text.trim() == '1234') {
                Navigator.pop(context); // إغلاق صندوق الحوار
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرمز السري الخاص بالمشرف غير صحيح')),
                );
              }
            },
            child: const Text('دخول', style: TextStyle(color: Color(0xFFFFD700))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        title: const Text(
          'سوق السلع المعمدة',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // تم إصلاح وإكمال الكود المقطوع هنا لاستدعاء دالة التحقق عند الضغط
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Color(0xFFFFD700)),
            onPressed: () => _promptAdminAccess(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'محتوى سوق السلع المعمدة يظهر هنا',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

// كلاس افتراضي للوحة تحكم الإدارة لتفادي أخطاء البناء (استبدله بكود لوحة التحكم الخاصة بك إذا كانت جاهزة)
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المشرف'),
        backgroundColor: const Color(0xFF141414),
      ),
      body: const Center(
        child: Text('مرحباً بك في لوحة التحكم الخاصة بالإدارة'),
      ),
    );
  }
}
