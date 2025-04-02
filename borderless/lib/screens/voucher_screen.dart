import 'package:flutter/material.dart';

class VoucherCodes {
  static final Map<String, double> codes = {
    'DISCOUNT10': 0.10, // 10% off
    'FREESHIP': 5.00, // $5 off for shipping
    'WELCOME20': 0.20, // 20% off for first-time users
  };

  static double? getDiscount(String code) {
    return codes[code];
  }
}

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final TextEditingController _voucherController = TextEditingController();
  String? _appliedVoucher;
  double? _discountAmount;
  bool _isLoading = false;

  void _applyVoucher() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      final code = _voucherController.text.toUpperCase();
      final discount = VoucherCodes.getDiscount(code);

      setState(() {
        if (discount != null) {
          _appliedVoucher = code;
          _discountAmount = discount;
        } else {
          _appliedVoucher = null;
          _discountAmount = null;
        }
        _isLoading = false;
      });

      if (discount != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Voucher applied successfully! ${discount * 100}% off'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid voucher code'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _removeVoucher() {
    setState(() {
      _appliedVoucher = null;
      _discountAmount = null;
      _voucherController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vouchers'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Voucher Input Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Voucher Code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _voucherController,
                          decoration: InputDecoration(
                            hintText: 'Enter code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.local_offer),
                          ),
                          enabled: _appliedVoucher == null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (_appliedVoucher == null)
                        ElevatedButton(
                          onPressed: _isLoading ? null : _applyVoucher,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Apply'),
                        )
                      else
                        ElevatedButton(
                          onPressed: _removeVoucher,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Remove'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Available Vouchers Section
            const Text(
              'Available Vouchers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...VoucherCodes.codes.entries.map((entry) {
              final isApplied = _appliedVoucher == entry.key;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isApplied ? Colors.green : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_offer,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    entry.value < 1
                        ? '${(entry.value * 100).toInt()}% off'
                        : '\$${entry.value.toStringAsFixed(2)} off',
                  ),
                  trailing: isApplied
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              _voucherController.text = entry.key;
                            });
                            _applyVoucher();
                          },
                          child: const Text('Apply'),
                        ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }
}
