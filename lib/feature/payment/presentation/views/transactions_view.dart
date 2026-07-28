import 'package:experience_app/feature/payment/domain/entities/payment_transaction.dart';
import 'package:experience_app/feature/payment/presentation/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:experience_app/core/navigation/router.dart';

class TransactionsView extends ConsumerWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pushNamed(Routes.home),
        ),
        title: const Text(
          'Mis transacciones',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: txAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const Center(
          child: Text('No se pudieron cargar tus transacciones'),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                'Aún no tienes transacciones',
                style: TextStyle(color: Color(0xFF71727A)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return GestureDetector(
                onTap: () => _showTransactionDetail(context, tx),
                child: _TransactionTile(transaction: tx),
              );
            },
          );
        },
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, PaymentTransaction tx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E9F1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Center(
              child: Icon(
                statusIconFor(tx.status),
                size: 48,
                color: statusColorFor(tx.status),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '\$ ${tx.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                statusLabelFor(tx.status),
                style: TextStyle(
                  color: statusColorFor(tx.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            _detailRow('Concepto', tx.concept),
            _detailRow(
              'Fecha',
              DateFormat('dd/MM/yyyy - HH:mm').format(tx.date),
            ),
            _detailRow('Tarjeta', '**** ${tx.cardLast4}'),
            if (tx.transactionId != null)
              _detailRow('ID de transacción', tx.transactionId!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006FFD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Cerrar',
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
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF71727A))),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final PaymentTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat(
      'dd/MM/yyyy - HH:mm',
    ).format(transaction.date);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColorFor(transaction.status).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIconFor(transaction.status),
              color: statusColorFor(transaction.status),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.concept,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormatted,
                  style: const TextStyle(
                    color: Color(0xFF71727A),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusLabelFor(transaction.status),
                  style: TextStyle(
                    color: statusColorFor(transaction.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$ ${transaction.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

Color statusColorFor(String status) {
  switch (status) {
    case 'approved':
      return const Color(0xFF17BB6D);
    case 'declined':
    case 'error':
      return const Color(0xFFE9394A);
    case 'insufficient_funds':
      return const Color(0xFFFFA133);
    default:
      return const Color(0xFF71727A);
  }
}

IconData statusIconFor(String status) {
  switch (status) {
    case 'approved':
      return Icons.check_circle_outline;
    case 'declined':
    case 'error':
      return Icons.cancel_outlined;
    case 'insufficient_funds':
      return Icons.warning_amber_outlined;
    default:
      return Icons.receipt_long_outlined;
  }
}

String statusLabelFor(String status) {
  switch (status) {
    case 'approved':
      return 'Aprobada';
    case 'declined':
      return 'Rechazada';
    case 'insufficient_funds':
      return 'Fondos insuficientes';
    case 'error':
      return 'Error de conexión';
    default:
      return status;
  }
}
