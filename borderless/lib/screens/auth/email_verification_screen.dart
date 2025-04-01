import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';

class EmailVerificationScreen extends StatefulWidget {
  final bool isForgotPassword;
  const EmailVerificationScreen({
    super.key,
    this.isForgotPassword = false,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late AnimationController _toastController;
  late Animation<double> _toastAnimation;
  bool _showToast = true;
  bool _isLoading = false;
  String? _error;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _toastController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _toastAnimation = CurvedAnimation(
      parent: _toastController,
      curve: Curves.easeInOut,
    );
    _toastController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _toastController.reverse().then((_) {
          setState(() {
            _showToast = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _toastController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  Future<void> _handleVerification(String userId) async {
    final code = _controllers.map((controller) => controller.text).join();

    if (code.length != 6) {
      setState(() {
        _error = 'Please enter all 6 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _authService.verifyOTP(userId, code);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        context.read<AuthBloc>().add(CheckAuth());
        if (widget.isForgotPassword) {
          Navigator.pushReplacementNamed(context, '/reset-password');
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } else {
        setState(() {
          _error = result['error'] ?? 'Invalid verification code.';
        });
      }
    }
  }

  Future<void> _handleResendCode(String userId, String email) async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authService.resendOTP(userId, email);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result != null && result.containsKey('otp')) {
          _showToast = true;
          _toastController.forward();

          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              _toastController.reverse().then((_) {
                setState(() {
                  _showToast = false;
                });
              });
            }
          });
        } else {
          _error = result?['error'] ?? 'Failed to resend code.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final email = args?['email'] as String? ?? '';
    final userId = args?['userId'] as String? ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Text(
                          'B',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF21D4B4),
                          ),
                        ),
                        const Text(
                          'ORDERLESS',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.isForgotPassword ? 'Reset Password' : 'Verify Email',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.isForgotPassword
                        ? 'We have sent a verification code to your email address. Please enter the code to reset your password.'
                        : 'We have sent a verification code to your email address. Please enter the code to verify your account.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                          (index) => SizedBox(
                        width: 50,
                        height: 56,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          enabled: !_isLoading,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _error != null ? Colors.red : Colors.grey[200]!,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF21D4B4)),
                            ),
                          ),
                          onChanged: (value) => _onCodeChanged(value, index),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive code? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      GestureDetector(
                        onTap: !_isLoading ? () => _handleResendCode(userId, email) : null,
                        child: Text(
                          'Resend Code',
                          style: TextStyle(
                            fontSize: 14,
                            color: _isLoading
                                ? Color(0xFF21D4B4).withOpacity(0.5)
                                : Color(0xFF21D4B4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _handleVerification(userId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Text(
                        widget.isForgotPassword ? 'Reset Password' : 'Verify Email',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showToast)
              Positioned(
                top: 16,
                left: 24,
                right: 24,
                child: FadeTransition(
                  opacity: _toastAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF21D4B4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF21D4B4),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Verification code sent to $email',
                            style: TextStyle(
                              color: Color(0xFF21D4B4),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}