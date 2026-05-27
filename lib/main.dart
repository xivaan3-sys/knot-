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
          side: const BorderSide(color: Color(0xFFFFD700), width: 1), // تم تصحيح الـ Border هنا
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
            child: const Text('دخول', style: TextStyle(color: Color(0xFFFFD700))), // تم إكمال زر الدخول هنا
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
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colo
