import 'package:experience_app/feature/auth/presentation/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:experience_app/core/navigation/router.dart';
import 'package:experience_app/feature/ecommerce/presentation/provider/bag_provider.dart';
import 'package:experience_app/feature/payment/data/datasources/payment_remote_datasource.dart';
import 'package:experience_app/feature/payment/domain/entities/credit_card.dart';
import 'package:experience_app/feature/payment/domain/entities/payment_transaction.dart';
import 'package:experience_app/feature/payment/presentation/provider/payment_provider.dart';
import 'package:experience_app/feature/payment/presentation/provider/transactions_provider.dart';

class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({super.key});

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(paymentProvider);
    final selected = ref.watch(selectedCardProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pushNamed(Routes.home),
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

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE8E9F1)),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [
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

                            cardsAsync.when(
                              loading: () => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: CircularProgressIndicator(),
                              ),
                              error: (error, _) => const Text(
                                'No se pudieron cargar tus tarjetas',
                              ),
                              data: (cards) {
                                if (cards.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      'Aún no tienes tarjetas guardadas',
                                      style: TextStyle(
                                        color: Color(0xFF8F9098),
                                      ),
                                    ),
                                  );
                                }
                                return ListView.builder(
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
                                        margin: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFFEAF2FF)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE8E9F1),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    card.brand,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                            ),
                                            if (isSelected)
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  right: 4,
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Color(0xFF006FFD),
                                                ),
                                              ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                                size: 20,
                                                color: Color(0xFF71727A),
                                              ),
                                              onPressed: () {
                                                context.pushNamed(
                                                  Routes.addCard,
                                                  extra: card,
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  _confirmDeleteCard(card),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            TextButton(
                              onPressed: () =>
                                  context.pushNamed(Routes.addCard),
                              child: const Text(
                                '+ Add new card',
                                style: TextStyle(
                                  color: Color(0xFF006FFD),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

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
                                border: Border.all(
                                  color: const Color(0xFFC5C6CC),
                                ),
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
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

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
                  onPressed: isProcessing
                      ? null
                      : () {
                          final cards = cardsAsync.value ?? [];
                          if (cards.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Agrega una tarjeta primero'),
                              ),
                            );
                            return;
                          }
                          _processPayment(cards[selected]);
                        },
                  child: isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
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

  void _confirmDeleteCard(CreditCardEntity card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar tarjeta'),
        content: Text('¿Deseas eliminar la tarjeta ${card.maskedNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(paymentProvider.notifier).removeCard(card.id);
      ref.read(selectedCardProvider.notifier).selectCard(0);
    }
  }

  Future<void> _processPayment(CreditCardEntity card) async {
    final bagItems = ref.read(bagProvider);
    final total = ref.read(bagProvider.notifier).totalPrice;

    if (bagItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tu bolsa está vacía')));
      return;
    }

    setState(() => isProcessing = true);

    final dataSource = PaymentRemoteDataSource();
    final result = await dataSource.processPayment(
      amount: total,
      cardNumber: card.cardNumber,
      currency: 'USD',
    );

    final concept = bagItems.length == 1
        ? bagItems.first.product.name
        : '${bagItems.first.product.name} y ${bagItems.length - 1} producto(s) más';

    final uid = ref.read(authProvider).value?.uid;
    if (uid != null) {
      await ref
          .read(transactionDataSourceProvider)
          .saveTransaction(
            uid,
            PaymentTransaction(
              id: '',
              amount: total,
              currency: 'USD',
              concept: concept,
              status: result.status,
              cardLast4: result.cardLast4,
              transactionId: result.transactionId,
              date: DateTime.now(),
            ),
          );
    }

    if (!mounted) return;
    setState(() => isProcessing = false);

    if (result.success) {
      await ref.read(bagProvider.notifier).clearBag();
      if (!mounted) return;
      _showResultDialog(
        title: 'Pago aprobado',
        message: result.message,
        primaryLabel: 'Ver mis transacciones',
        onPrimary: () {
          Navigator.pop(context);
          context.goNamed(Routes.transactions);
        },
      );
    } else {
      _showResultDialog(
        title: 'Pago no procesado',
        message: result.message,
        primaryLabel: 'Intentar con otra tarjeta',
        onPrimary: () => Navigator.pop(context),
      );
    }
  }

  void _showResultDialog({
    required String title,
    required String message,
    required String primaryLabel,
    required VoidCallback onPrimary,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: onPrimary, child: Text(primaryLabel))],
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
