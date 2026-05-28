import 'package:experience_app/core/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:experience_app/feature/payment/domain/entities/credit_card.dart';
import 'package:experience_app/feature/payment/presentation/provider/payment_provider.dart';
import 'package:flutter/services.dart';

class AddCardView extends ConsumerStatefulWidget {
  const AddCardView({super.key});
  @override
  ConsumerState<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends ConsumerState<AddCardView> {
  final holderController = TextEditingController();
  final numberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  /// DETECT CARD BRAND
  String detectCardBrand(String number) {
    if (number.startsWith('4')) {
      return 'Visa';
    }
    if (number.startsWith('5') || number.startsWith('2')) {
      return 'Mastercard';
    }
    if (number.startsWith('34') || number.startsWith('37')) {
      return 'Amex';
    }
    if (number.startsWith('6')) {
      return 'Discover';
    }
    return 'Card';
  }

  /// CARD COLORS
  List<Color> getCardColors(String brand) {
    switch (brand) {
      case 'Visa':
        return [const Color(0xFF006FFD), const Color(0xFF4395D1)];
      case 'Mastercard':
        return [const Color(0xFFFF6B00), const Color(0xFFFFA133)];
      case 'Amex':
        return [const Color(0xFF00A8E1), const Color(0xFF5DD6FF)];
      case 'Discover':
        return [const Color(0xFFFF6F00), const Color(0xFFFFB74D)];
      default:
        return [const Color(0xFF6F7078), const Color(0xFF9E9E9E)];
    }
  }

  /// FORMAT CARD NUMBER
  String formatCardNumber(String text) {
    text = text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final brand = detectCardBrand(numberController.text);
    final colors = getCardColors(brand);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.goNamed(Routes.checkout);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF006FFD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Text(
                    'Add Card',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
              const SizedBox(height: 32),

              /// CARD PREVIEW
              Container(
                width: double.infinity,
                height: 220,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// BRAND
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        brand,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),

                    /// CARD NUMBER
                    Text(
                      numberController.text.isEmpty
                          ? 'XXXX XXXX XXXX XXXX'
                          : formatCardNumber(numberController.text),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// HOLDER
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CARD HOLDER',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              holderController.text.isEmpty
                                  ? 'YOUR NAME'
                                  : holderController.text.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        /// EXPIRY
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'EXPIRES',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              expiryController.text.isEmpty
                                  ? 'MM/YY'
                                  : expiryController.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              /// HOLDER INPUT
              _buildInput(
                label: 'Card Holder',
                controller: holderController,
                hint: 'John Doe',
              ),
              const SizedBox(height: 20),

              /// NUMBER INPUT
              _buildInput(
                label: 'Card Number',
                controller: numberController,
                hint: '4242 4242 4242 4242',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  CardNumberFormatter(),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildInput(
                      label: 'Expiry',
                      controller: expiryController,
                      hint: 'MM/YY',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        ExpiryDateFormatter(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInput(
                      label: 'CVV',
                      controller: cvvController,
                      hint: '1234',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006FFD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () async {
                    final card = CreditCardEntity(
                      holderName: holderController.text,
                      cardNumber: numberController.text,
                      expiryDate: expiryController.text,
                      cvv: cvvController.text,
                      brand: detectCardBrand(numberController.text),
                    );
                    await ref.read(paymentProvider.notifier).addCard(card);
                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  child: const Text(
                    'Save Card',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: (_) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE8E9F1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFF006FFD), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);

      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', ' ');

    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
