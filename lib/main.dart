import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Node',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          surface: Color(0xFF141414),
        ),
      ),
      home: const AppNavigationController(),
    );
  }
}

// متحكم التنقل العام بين شاشات التطبيق
class AppNavigationController extends StatefulWidget {
  const AppNavigationController({super.key});

  @override
  State<AppNavigationController> createState() => _AppNavigationControllerState();
}

class _AppNavigationControllerState extends State<AppNavigationController> {
  String _currentScreen = 'login'; // login, otp, main, add_product, escrow
  String _currentUserPhone = '';
  bool _isSellerVerified = false;
  Map<String, dynamic>? _selectedProductForEscrow;

  void _navigateTo(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case 'login':
        return LoginScreen(
          onBypassLogin: () {
            setState(() {
              _currentUserPhone = "+1 415 555 2671";
            });
            _navigateTo('main');
          },
          onSendOTP: () {
            _navigateTo('otp');
          },
        );
      case 'otp':
        return OtpScreen(
          onVerify: () {
            setState(() {
              _currentUserPhone = "+1 415 555 2671";
            });
            _navigateTo('main');
          },
          onBack: () => _navigateTo('login'),
        );
      case 'main':
        return MainSectionsScreen(
          userPhone: _currentUserPhone,
          isSellerVerified: _isSellerVerified,
          onVerificationSuccess: () {
            setState(() {
              _isSellerVerified = true;
            });
          },
          onNavigateToAddProduct: () {
            _navigateTo('add_product');
          },
          onStartEscrow: (product) {
            setState(() {
              _selectedProductForEscrow = product;
            });
            _navigateTo('escrow');
          },
        );
      case 'add_product':
        return AddProductScreen(
          onBack: () => _navigateTo('main'),
          onSubmit: () {
            _navigateTo('main');
          },
        );
      case 'escrow':
        return EscrowScreen(
          product: _selectedProductForEscrow ?? {},
          buyerPhone: _currentUserPhone,
          onBack: () => _navigateTo('main'),
        );
      default:
        return const Scaffold(body: Center(child: Text('Error')));
    }
  }
}

// ==========================================
// 1. LOGIN SCREEN
// ==========================================
class LoginScreen extends StatelessWidget {
  final VoidCallback onBypassLogin;
  final VoidCallback onSendOTP;

  const LoginScreen({
    super.key,
    required this.onBypassLogin,
    required this.onSendOTP,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('👑', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 10),
              const Text(
                'TECH NODE',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const SizedBox(height: 5),
              const Text(
                'سوق الضمان والسلع الرقمية المعتمدة',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 40),
              TextField(
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'رقم الهاتف (مثال: +1...)',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF141414),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء الضغط على زر التخطي (وضع المعاينة) لتشغيل التطبيق أوفلاين كلياً.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('إرسال رمز التحقق 🚀', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: onBypassLogin,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF333333)),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('تخطي ودخول تجريبي (أوفلاين) 👁️'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. OTP SCREEN
// ==========================================
class OtpScreen extends StatelessWidget {
  final VoidCallback onVerify;
  final VoidCallback onBack;

  const OtpScreen({super.key, required this.onVerify, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔒', style: TextStyle(fontSize: 50)),
              const SizedBox(height: 10),
              const Text('أدخل رمز التحقق', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, letterSpacing: 4),
                decoration: InputDecoration(
                  hintText: 'XXXXXX',
                  hintStyle: const TextStyle(color: Colors.grey, letterSpacing: 0),
                  filled: true,
                  fillColor: const Color(0xFF141414),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onVerify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('تحقق ودخول'),
              ),
              TextButton(
                onPressed: onBack,
                child: const Text('تغيير رقم الهاتف', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. MAIN APP (WITH TAB NAVIGATION)
// ==========================================
class MainSectionsScreen extends StatefulWidget {
  final String userPhone;
  final bool isSellerVerified;
  final VoidCallback onVerificationSuccess;
  final VoidCallback onNavigateToAddProduct;
  final Function(Map<String, dynamic>) onStartEscrow;

  const MainSectionsScreen({
    super.key,
    required this.userPhone,
    required this.isSellerVerified,
    required this.onVerificationSuccess,
    required this.onNavigateToAddProduct,
    required this.onStartEscrow,
  });

  @override
  State<MainSectionsScreen> createState() => _MainSectionsScreenState();
}

class _MainSectionsScreenState extends State<MainSectionsScreen> {
  int _activeTabIndex = 0; // 0: Market, 1: Wallet, 2: Verify, 3: Admin
  String _activeCategory = 'All';

  final List<Map<String, String>> _categories = [
    {'name': 'All', 'arName': 'الكل', 'icon': '📋', 'desc': 'كافة السلع المعروضة.'},
    {'name': 'Telegram', 'arName': 'تليجرام', 'icon': '✈️', 'desc': 'فحص تاريخ الإنشاء، نوع القناة (عامة/خاصة)، وصحة يوزر القناة.'},
    {'name': 'WhatsApp', 'arName': 'واتساب', 'icon': '💬', 'desc': 'فحص نشاط الرقم البرمجي، وقابليته لاستقبال كود التفعيل.'},
    {'name': 'YouTube', 'arName': 'يوتيوب', 'icon': '📺', 'desc': 'فحص عدد المشتركين الحقيقيين، معدل المشاهدات، وحالة تحقيق الربح.'},
    {'name': 'TikTok', 'arName': 'تيك توك', 'icon': '🎵', 'desc': 'فحص نوع الحساب (بيتا)، ومعدل التفاعل الإجمالي للجمهور.'},
    {'name': 'Facebook', 'arName': 'فيسبوك', 'icon': '👥', 'desc': 'فحص جودة الصفحة الفنية وتاريخ التأسيس الأساسي.'},
    {'name': 'Instagram', 'arName': 'إنستقرام', 'icon': '📸', 'desc': 'فحص جودة اليوزرات وقوة تفاعل الحساب.'},
    {'name': 'Snapchat', 'arName': 'سناب شات', 'icon': '👻', 'desc': 'فحص نقاط الحساب (Score) ونوع اسم اليوزر المتاح.'},
    {'name': 'Twitter', 'arName': 'إكس', 'icon': '🐦', 'desc': 'فحص تاريخ الانضمام القديم وقوة توثيق الحساب.'},
    {'name': 'VirtualNumbers', 'arName': 'أرقام وهمية', 'icon': '🔢', 'desc': 'فحص صلاحية الرقم للتفعيل الفوري المباشر.'},
    {'name': 'Other', 'arName': 'خدمات أخرى', 'icon': '🛠️', 'desc': 'فحص يدوي وآلي لمواصفات الخدمة والوصف.'},
  ];

  final List<Map<String, dynamic>> _mockProducts = [
    { "id": "t1", "title": "Premium Telegram Channel 50k - Verified Owner", "user": "+1 415 555 2671", "price": "220", "category": "Telegram" },
    { "id": "w1", "title": "Verified WhatsApp Virtual Number for Instant Use", "user": "+44 20 7946 0958", "price": "20", "category": "WhatsApp" },
    { "id": "y1", "title": "YouTube Channel Monetized 12k Active Subscribers", "user": "+1 212 555 0143", "price": "350", "category": "YouTube" },
    { "id": "inst1", "title": "Instagram Profile 100k - High Engagement Rate", "user": "+1 312 555 0199", "price": "450", "category": "Instagram" }
  ];

  void _promptAdminAccess() {
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF141414),
          title: const Text('إذن دخول الإدارة', style: TextStyle(color: Color(0xFFFFD700))),
          content: TextField(
            controller: pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'أدخل الرمز السري (1234)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (pinController.text == '1234') {
                  Navigator.pop(context);
                  setState(() {
                    _activeTabIndex = 3;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرمز السري غير صحيح')),
                  );
                }
              },
              child: const Text('دخول', style: TextStyle(color: Color(0xFFFFD700))),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
    final categoryData = _categories.firstWhere(
      (c) => c['name'] == product['category'],
      orElse: () => {'desc': 'فحص تقني شامل وموثق.'},
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ProductDetailBottomSheet(
          product: product,
          categoryDesc: categoryData['desc'] ?? '',
          onBuy: () {
            Navigator.pop(context);
            widget.onStartEscrow(product);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        leading: const SizedBox(width: 40),
        title: const Text(
          'TECH NODE MARKET',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFFFD700)),
            onPressed: () {
              if (!widget.isSellerVerified) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يجب توثيق هويتك أولاً في قسم Verify ID لتتمكن من رفع سلع.')),
                );
                setState(() {
                  _activeTabIndex = 2; // انتقال لتوثيق الهوية
                });
              } else {
                widget.onNavigateToAddProduct();
              }
            },
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _activeTabIndex,
                children: [
                  _buildMarketTab(),
                  _buildWalletTab(),
                  _buildVerifyTab(),
                  _buildAdminTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeTabIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF141414),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 3) {
            _promptAdminAccess();
          } else {
            setState(() {
              _activeTabIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Market'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: 'Verify ID'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Admin'),
        ],
      ),
    );
  }

  Widget _buildMarketTab() {
    final filteredProducts = _activeCategory == 'All'
        ? _mockProducts
        : _mockProducts.where((p) => p['category'] == _activeCategory).toList();

    return Column(
      children: [
        // شريط الأقسام الأفقي
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          color: const Color(0xFF141414).withOpacity(0.5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _activeCategory == cat['name'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ChoiceChip(
                  label: Text('${cat['icon']} ${cat['name']}'),
                  selected: isSelected,
                  selectedColor: const Color(0xFFFFD700).withOpacity(0.1),
                  backgroundColor: const Color(0xFF141414),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFFFFD700) : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _activeCategory = cat['name']!;
                    });
                  },
                ),
              );
            },
          ),
        ),
        // قائمة المنتجات
        Expanded(
          child: filteredProducts.isEmpty
              ? const Center(
                  child: Text('لا توجد سلع متوفرة في هذا القسم حالياً.', style: TextStyle(color: Colors.grey)),
                )
              : ListView.builder(
                  itemCount: filteredProducts.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: () => _showProductDetail(product),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['title'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                      Text('البائع: ${product['user']}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                    ],
                                  ),
                                ),
                                const Text('👑', style: TextStyle(fontSize: 40)),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              height: 1,
                              color: const Color(0xFF1C1C1C),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A0A0A),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFF222222)),
                                  ),
                                  child: Text(
                                    product['category'],
                                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                ),
                                Text('\$${product['price']}', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildWalletTab() {
    final payIdController = TextEditingController();
    final amountController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.1)),
            ),
            child: const Column(
              children: [
                Text('Available Wallet Balance', style: TextStyle(color: Colors.grey, fontSize: 12)),
                SizedBox(height: 8),
                Text(
                  '\$0.00 USDT',
                  style: TextStyle(color: Color(0xFFFFD700), fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('طلب سحب رصيد الخزانة (Binance Pay):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 15),
                TextField(
                  controller: payIdController,
                  decoration: InputDecoration(
                    hintText: 'أدخل معرف Binance Pay ID الخاص بك',
                    filled: true,
                    fillColor: const Color(0xFF0A0A0A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'المبلغ المطلوب سحبه بالدولار',
                    filled: true,
                    fillColor: const Color(0xFF0A0A0A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (payIdController.text.isEmpty || amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء تعبئة كافة الحقول')));
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم رفع طلب سحب بمبلغ \$${amountController.text} إلى معرف Binance الخاص بك بنجاح.')),
                    );
                    payIdController.clear();
                    amountController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('تقديم طلب سحب معتمد للمدير', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVerifyTab() {
    String docType = 'passport';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: const Text(
              'تنبيه أمني: لا يُسمح للبائعين برفع أو نشر أي سلع في المنصة إلا بعد تفعيل "توثيق الهوية" لضمان سلامة التعاملات ومكافحة الاحتيال.',
              style: TextStyle(fontSize: 11, height: 1.5, color: Colors.redAccent),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('نوع الوثيقة الرسمية لتوثيق الهوية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: docType,
                  dropdownColor: const Color(0xFF141414),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0A0A0A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'passport', child: Text('جواز السفر الدولي')),
                    DropdownMenuItem(value: 'id_card', child: Text('البطاقة الشخصية (الهوية الوطنية)')),
                    DropdownMenuItem(value: 'license', child: Text('رخصة القيادة الرسمية')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      docType = val;
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.onVerificationSuccess();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تمت المحاكاة: تم توثيق هويتك بنجاح وبإمكانك الآن رفع السلع للبيع!')),
                    );
                    setState(() {
                      _activeTabIndex = 0; // العودة للماركت
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('تفعيل توثيق الهوية الآن', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAdminTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('طلبات السلع المعلقة للنشر:', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('طلب نشر معتمد: قناة تليجرام 50k', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('\$250', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5),
                const Text('البائع: +1 415 555 2671', style: TextStyle(color: Colors.grey, fontSize: 10)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الموافقة على السلعة ونشرها بنجاح!')));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('موافقة ونشر', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفض وحذف السلعة المعلقة.')));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('رفض وحذف', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 4. DETAILED PRODUCT MODAL WITH TERMINAL SIMULATOR
// ==========================================
class ProductDetailBottomSheet extends StatefulWidget {
  final Map<String, dynamic> product;
  final String categoryDesc;
  final VoidCallback onBuy;

  const ProductDetailBottomSheet({
    super.key,
    required this.product,
    required this.categoryDesc,
    required this.onBuy,
  });

  @override
  State<ProductDetailBottomSheet> createState() => _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  bool _isChecking = false;
  bool _checkCompleted = false;
  final List<String> _terminalLogs = [];

  void _startBotCheck() async {
    setState(() {
      _isChecking = true;
      _terminalLogs.clear();
      _terminalLogs.add('> Initializing Bot handshake...');
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _terminalLogs.add('> Sending auth query to ${widget.product['category']} Node API...');
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _terminalLogs.add('> Inspecting public statistics & channel metadata...');
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _terminalLogs.add('> Verifying ownership records...');
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _terminalLogs.add('STATUS: SECURE & VERIFIED (PASS) ✅');
      _checkCompleted = true;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.product['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 5),
                    Text('القسم: ${widget.product['category']}', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Text('Verified Seller: ${widget.product['user']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 5),
            Text('السعر: \$${widget.product['price']} USDT', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 20),

            // نظام الفحص الفني الآلي للبوت
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF222222)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🤖 نظام الفحص الفني الآلي للسلعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 5),
                  Text(widget.categoryDesc, style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.4)),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _isChecking ? null : _startBotCheck,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700).withOpacity(0.1),
                      side: const BorderSide(color: Color(0xFFFFD700), width: 0.5),
                    ),
                    child: Text(
                      _isChecking ? 'جاري الفحص المباشر...' : 'بدء الفحص الآلي الذكي 🤖',
                      style: const TextStyle(color: Color(0xFFFFD700)),
                    ),
                  ),
                  if (_terminalLogs.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _terminalLogs
                            .map((log) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    log,
                                    style: TextStyle(
                                      color: log.contains('STATUS') ? Colors.green : Colors.grey,
                                      fontFamily: 'monospace',
                                      fontSize: 10,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    )
                  ]
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('شراء عبر وسيط معتمد 👑', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 5. ADD PRODUCT SCREEN
// ==========================================
class AddProductScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const AddProductScreen({super.key, required this.onBack, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: const Text('Add Verified Listing'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'عنوان السلعة (مثال: قناة تليجرام 50k)',
                  filled: true,
                  fillColor: const Color(0xFF141414),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'السعر بـ USDT ($)',
                  filled: true,
                  fillColor: const Color(0xFF141414),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: 'Telegram',
                dropdownColor: const Color(0xFF141414),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF141414),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                items: const [
                  DropdownMenuItem(value: 'Telegram', child: Text('Telegram')),
                  DropdownMenuItem(value: 'WhatsApp', child: Text('WhatsApp')),
                  DropdownMenuItem(value: 'YouTube', child: Text('YouTube')),
                ],
                onChanged: (val) {},
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إرسال طلب نشر السلعة للمراجعة من قبل المشرفين.')),
                  );
                  onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('إرسال للمراجعة والنشر', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. ESCROW ROOM SCREEN (غرفة الضمان)
// ==========================================
class EscrowScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final String buyerPhone;
  final VoidCallback onBack;

  const EscrowScreen({
    super.key,
    required this.product,
    required this.buyerPhone,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: const Text('Escrow Middleman (وسيط معتمد)'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: onBack),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🛡️', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 20),
                  Text(product['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text('البائع: ${product['user'] ?? ""}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 5),
                  Text('المشتري (أنت): $buyerPhone', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 15),
                  Text('السعر المتفق عليه: \$${product['price'] ?? ""} USDT', style: const TextStyle(color: Color(0xFFFFD700), fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.2)),
                    ),
                    child: const Text(
                      'تنبيه: الغرفة آمنة وموثقة تماماً. سيقوم المشرف الآن بمراجعة العملية والتواصل لتسهيل تحويل الأموال بأمان وتأمين تسليم السلعة وحفظ حقوق الطرفين.',
                      style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF333333)),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('العودة للسوق المفتوح'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
