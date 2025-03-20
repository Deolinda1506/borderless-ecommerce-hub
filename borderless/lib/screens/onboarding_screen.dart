import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constants/app_colors.dart';
import '../widgets/onboarding_page.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      image: 'assets/images/shopping.svg',
      title: 'Explore a wide range of products',
      description:
          'Explore a wide range of products at your fingertips. Borderless offers an extensive collection to suit your needs.',
    ),
    OnboardingPageData(
      image: 'assets/images/voucher.svg',
      title: 'Unlock exclusive offers and discounts',
      description:
          'Get access to limited-time deals and special promotions available only to our valued customers.',
    ),
    OnboardingPageData(
      image: 'assets/images/secure.svg',
      title: 'Safe and secure payments',
      description:
          'Borderless employs industry-leading encryption and trusted payment gateways to safeguard your financial information.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToSignup() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignupScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _onNextPressed() {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToSignup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage == 0
                      ? const SizedBox(width: 40)
                      : IconButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                  TextButton(
                    onPressed: _navigateToSignup,
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(data: pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: pages.length,
                    effect: WormEffect(
                      dotColor: AppColors.grey.withOpacity(0.3),
                      activeDotColor: AppColors.primary,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (_currentPage == pages.length - 1) ...[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text('Login'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _onNextPressed,
                          child: const Text('Get Started'),
                        ),
                      ] else
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _onNextPressed,
                            child: const Text('Next'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

