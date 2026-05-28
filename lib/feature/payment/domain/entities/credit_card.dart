class CreditCardEntity {
  final String holderName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String brand;

  CreditCardEntity({
    required this.holderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.brand,
  });

  String get maskedNumber {
    return 'xxxx xxxx xxxx ${cardNumber.substring(cardNumber.length - 4)}';
  }
}
