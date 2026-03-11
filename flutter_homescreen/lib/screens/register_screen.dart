import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final bool isEdit; // ถ้า true จะแสดงเป็นโหมดแก้ไข

  const RegisterScreen({super.key, this.isEdit = false});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // สร้าง GlobalKey สำหรับ Form
  final _formKey = GlobalKey<FormState>();
  
  // Controllers สำหรับ TextFormField
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // State สำหรับ Show/Hide Password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    // อย่าลืม dispose controllers!
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ฟังก์ชัน Validate Email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    // ใช้ RegExp ตรวจสอบรูปแบบอีเมล
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
    }
    return null;
  }
  // ฟังก์ชัน Validate Phone
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกเบอร์โทร';
    }
    else if (value.length != 10){
      return 'เบอร์โทรต้องมี 10 ตัว';
    }
    return null;
  }
  // ฟังก์ชัน Validate Password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }
    if (value.length < 6) {
      return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
    }
    return null;
  }

  // ฟังก์ชันจัดการการลงทะเบียน
  void _handleRegister() {
    // ตรวจสอบ Form ว่าผ่าน Validation หรือไม่
    if (_formKey.currentState!.validate()) {
      // แสดง SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEdit ? 'แก้ไขข้อมูลเรียบร้อย' : 'ลงทะเบียนสำเร็จ!'),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.isEdit) {
        // ถ้าเป็นโหมดแก้ไข กลับไปหน้าก่อนหน้า
        Navigator.pop(context);
      } else {
        // Navigation ไปหน้า Login (แบบ Named Route)
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบสถานะ validity ของฟอร์ม (ใช้กับการเปิด/ปิดปุ่ม)
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'แก้ไขข้อมูล' : 'ลงทะเบียน'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // ผูก GlobalKey กับ Form
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ไอคอนด้านบน
              Icon(
                widget.isEdit ? Icons.edit : Icons.person_add,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 32),

              // ชื่อ
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ-นามสกุล',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // อีเมล
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'อีเมล',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail,
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // เบอร์โทร
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'เบอร์โทร',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // รหัสผ่าน
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  // ปุ่ม Show/Hide Password
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword 
                          ? Icons.visibility_off 
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: _validatePassword,
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // ยืนยันรหัสผ่าน
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'ยืนยันรหัสผ่าน',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword 
                          ? Icons.visibility_off 
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณายืนยันรหัสผ่าน';
                  }
                  // ตรวจสอบว่าตรงกับรหัสผ่านหรือไม่
                  if (value != _passwordController.text) {
                    return 'รหัสผ่านไม่ตรงกัน';
                  }
                  return null;
                },
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 24),

              // ปุ่มลงทะเบียน
              ElevatedButton(
                onPressed: isFormValid ? _handleRegister : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  widget.isEdit ? 'บันทึก' : 'ลงทะเบียน',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}