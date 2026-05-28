import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:experience_app/core/navigation/router.dart';
import 'package:experience_app/feature/payment/presentation/provider/payment_provider.dart';

class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(paymentProvider);
    final selected = ref.watch(selectedCardProvider);
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
                      context.pushNamed(Routes.home);
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
                    'Checkout',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
              const SizedBox(height: 32),

              /// STEPS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStep(completed: true, title: 'Your bag', number: '1'),
                  _buildStep(completed: true, title: 'Shipping', number: '2'),
                  _buildStep(
                    completed: false,
                    title: 'Payment',
                    number: '3',
                    active: true,
                  ),
                ],
              ),
              const SizedBox(height: 42),
              const Text(
                'Choose a payment method',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "You won't be charged until you review the order on the next page",
                style: TextStyle(color: Color(0xFF8F9098), fontSize: 15),
              ),
              const SizedBox(height: 28),

              /// CREDIT CARD CONTAINER
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE8E9F1)),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    /// TITLE
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF006FFD),
                          ),
                          child: const Center(
                            child: CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Credit Card',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    /// CARDS
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        final isSelected = selected == index;
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(selectedCardProvider.notifier)
                                .selectCard(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEAF2FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFE8E9F1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card.brand,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      card.maskedNumber,
                                      style: const TextStyle(
                                        color: Color(0xFF8F9098),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check,
                                    color: Color(0xFF006FFD),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    /// ADD CARD
                    TextButton(
                      onPressed: () {
                        context.pushNamed(Routes.addCard);
                      },
                      child: const Text(
                        '+ Add new card',
                        style: TextStyle(
                          color: Color(0xFF006FFD),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// CHECKBOX
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          activeColor: const Color(0xFF006FFD),
                          onChanged: (_) {},
                        ),
                        const Expanded(
                          child: Text(
                            'My billing address is the same as my shipping address',
                            style: TextStyle(color: Color(0xFF8F9098)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              /// APPLE PAY
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE8E9F1)),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFC5C6CC)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Apple Pay',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6F7078),
                      ),
                    ),
                  ],
                ),
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment processed')),
                    );
                  },
                  child: const Text(
                    'Process Payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  Widget _buildStep({
    required bool completed,
    required String title,
    required String number,
    bool active = false,
  }) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: active || completed ? const Color(0xFF006FFD) : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: completed
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            color: active ? Colors.black : const Color(0xFF8F9098),
          ),
        ),
      ],
    );
  }
}
