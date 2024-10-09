import 'package:flutter/material.dart';
import '../../service/AuthService.dart';
import './register_screen.dart'; 
import '../nav_bar_screen.dart';
import '../../utils/app_color.dart';
import '../../utils/images_path.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final AuthService _authService = AuthService();
  String? errorMessage;

  Future<void> _handleLogin(BuildContext context) async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    // Kiểm tra nếu người dùng chưa nhập email hoặc mật khẩu
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter both email and password';
      });
      return;
    }

    try {
      // Gọi API login từ AuthService
      final token = await _authService.login(email, password);
      if (token != null) {
        // Nếu đăng nhập thành công
        print('Login successful! Token: $token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      } else {
        setState(() {
          errorMessage = 'Wrong account or password';
        });
      }
    } catch (error) {
      // Xử lý lỗi đăng nhập
      setState(() {
        errorMessage = 'Wrong account or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: 327,
            child: Column(
              children: [
                Text(
                  'Hi, Welcome Back! 👋',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ).copyWith(color: AppColor.kGrayscaleDark100, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'We are happy to see you. Sign In to your account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.kWhite)
                      .copyWith(color: AppColor.kGrayscale40, fontSize: 14),
                ),
                const SizedBox(height: 36),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.kWhite)
                          .copyWith(
                              color: AppColor.kGrayscaleDark100,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    PrimaryTextFormField(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'user@gmail.com',
                      controller: emailC,
                      width: 327,
                      height: 52,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.kWhite)
                          .copyWith(
                              color: AppColor.kGrayscaleDark100,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    PasswordTextField(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'Password',
                      controller: passwordC,
                      width: 327,
                      height: 52,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Hiển thị thông báo lỗi nếu có
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryTextButton(
                      onPressed: () {},
                      title: 'Forgot Password?',
                      textStyle: const TextStyle(),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Column(
                  children: [
                    PrimaryButton(
                      elevation: 0,
                      onTap: () => _handleLogin(context),
                      text: 'LogIn',
                      bgColor: AppColor.kPrimary,
                      borderRadius: 20,
                      height: 46,
                      width: 327,
                      textColor: AppColor.kWhite,
                      fontSize: 14,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CustomRichText(
                        title: 'Don’t have an account?',
                        subtitle: ' Create here',
                        onTab: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        subtitleTextStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.kWhite)
                            .copyWith(
                                color: AppColor.kPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: Column(
                    children: [
                      const DividerRow(title: 'Or Sign In with'),
                      const SizedBox(height: 24),
                      SecondaryButton(
                          height: 56,
                          textColor: AppColor.kGrayscaleDark100,
                          width: 280,
                          onTap: () {},
                          borderRadius: 24,
                          bgColor: AppColor.kBackground.withOpacity(0.3),
                          text: 'Continue with Google',
                          icons: ImagesPath.kGoogleIcon),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TermsAndPrivacyText(
                    title1: '  By signing up you agree to our',
                    title2: ' Terms ',
                    title3: '  and',
                    title4: ' Conditions of Use',
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
