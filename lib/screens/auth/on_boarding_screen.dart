import 'package:flutter/material.dart';
import '../../utils/app_color.dart';
import '../../utils/images_path.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController1 = PageController(initialPage: 0);
  final PageController _pageController2 = PageController(initialPage: 0);
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kOnBoardingColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            height: 10,
            width: 10,
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.kPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 5,
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: onBoardinglist.length,
                physics: const BouncingScrollPhysics(),
                controller: _pageController1 ?? _pageController2,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnBoardingCard(
                    onBoardingModel: onBoardinglist[index],
                  );
                }),
          ),
          const SizedBox(height: 40),
          Center(
            child: DotsIndicator(
              dotsCount: onBoardinglist.length,
              position: _currentIndex,
              decorator: DotsDecorator(
                color: AppColor.kPrimary.withOpacity(0.4),
                size: const Size.square(8.0),
                activeSize: const Size(20.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                activeColor: AppColor.kPrimary,
              ),
            ),
          ),
          const SizedBox(height: 37),
          Expanded(
            flex: 2,
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: onBoardinglist.length,
                physics: const BouncingScrollPhysics(),
                controller: _pageController2 ?? _pageController1,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingTextCard(
                    onBoardingModel: onBoardinglist[index],
                  );
                }),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 23, bottom: 36),
            child: PrimaryButton(
              elevation: 0,
              onTap: () {
                if (_currentIndex == onBoardinglist.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  _pageController1.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                  _pageController2.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                }
              },
              text: _currentIndex == onBoardinglist.length - 1
                  ? 'Get Started'
                  : 'Next',
              bgColor: AppColor.kPrimary,
              borderRadius: 20,
              height: 46,
              width: 327,
              textColor: AppColor.kWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final double? fontSize;
  final IconData? iconData;
  final Color? textColor, bgColor;
  const PrimaryButton(
      {Key? key,
      required this.onTap,
      required this.text,
      this.width,
      this.height,
      this.elevation = 5,
      this.borderRadius,
      this.fontSize,
      required this.textColor,
      required this.bgColor,
      this.iconData})
      : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Card(
          elevation: widget.elevation ?? 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
          ),
          child: Container(
            height: widget.height ?? 55,
            alignment: Alignment.center,
            width: widget.width ?? double.maxFinite,
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(widget.borderRadius!),
            ),
            child: Text(
              widget.text,
              style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.kWhite)
                  .copyWith(
                      color: widget.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: widget.fontSize),
            ),
          ),
        ),
      ),
    );
  }
}

class OnBoardingCard extends StatefulWidget {
  OnBoarding onBoardingModel;
  OnBoardingCard({
    super.key,
    required this.onBoardingModel,
  });

  @override
  State<OnBoardingCard> createState() => _OnBoardingCardState();
}

class _OnBoardingCardState extends State<OnBoardingCard> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.onBoardingModel.image,
      height: 300,
      width: double.maxFinite,
      fit: BoxFit.fitWidth,
    );
  }
}

class OnboardingTextCard extends StatelessWidget {
  final OnBoarding onBoardingModel;
  const OnboardingTextCard({required this.onBoardingModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        children: [
          Text(
            onBoardingModel.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.kGrayscaleDark100,
            ).copyWith(fontSize: 24),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            onBoardingModel.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.kWhite)
                .copyWith(color: AppColor.kGrayscale40, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class OnBoarding {
  String title;
  String description;
  String image;

  OnBoarding({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<OnBoarding> onBoardinglist = [
  OnBoarding(
    title: 'Shop Sofas Anytime',
    image: ImagesPath.kOnboarding1,
    description: 'Explore our collection of high-quality sofas and shop comfortably from home, anytime. Say goodbye to the hassle of visiting physical stores—browse and buy with ease',
  ),
  OnBoarding(
    title: 'Tailored Designs',
    image: ImagesPath.kOnboarding2,
    description: 'From classic to contemporary, we offer a variety of sofa styles, colors, and materials, all customizable to match your preferences and home.',
  ),
  OnBoarding(
    title: 'Exclusive Discounts',
    image: ImagesPath.kOnboarding3,
    description: 'Get premium sofas at unbeatable prices with exclusive app-only offers and discounts for the best value.',
  ),
];


