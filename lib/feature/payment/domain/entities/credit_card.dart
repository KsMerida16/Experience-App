class CreditCardEntity {
  final String id;
  final String holderName;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String brand;
  final bool isActive;

  CreditCardEntity({
    this.id = '',
    required this.holderName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.brand,
    this.isActive = true,
  });

  String get maskedNumber {
    return 'xxxx xxxx xxxx ${cardNumber.substring(cardNumber.length - 4)}';
  }

  CreditCardEntity copyWith({
    String? id,
    String? holderName,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? brand,
    bool? isActive,
  }) {
    return CreditCardEntity(
      id: id ?? this.id,
      holderName: holderName ?? this.holderName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      brand: brand ?? this.brand,
      isActive: isActive ?? this.isActive,
    );
  }
}
