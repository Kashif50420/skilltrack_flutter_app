import 'package:flutter/material.dart';
import '../constants/constants.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> program;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.program,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String _selectedPaymentMethod = 'credit_card';
  bool _saveCardInfo = false;
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'credit_card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'color': Colors.blue,
    },
    {
      'id': 'paypal',
      'name': 'PayPal',
      'icon': Icons.payment,
      'color': Colors.blueAccent,
    },
    {
      'id': 'jazzcash',
      'name': 'JazzCash',
      'icon': Icons.phone_android,
      'color': Colors.green,
    },
    {
      'id': 'easypaisa',
      'name': 'EasyPaisa',
      'icon': Icons.phone_iphone,
      'color': Colors.orange,
    },
    {
      'id': 'bank_transfer',
      'name': 'Bank Transfer',
      'icon': Icons.account_balance,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final tax = widget.amount * 0.05;
    final total = widget.amount + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow('Program:', widget.program['title']),
                    _buildSummaryRow('Duration:', widget.program['duration']),
                    _buildSummaryRow(
                        'Course Fee:', '\$${widget.amount.toStringAsFixed(2)}'),
                    _buildSummaryRow(
                        'Tax (5%):', '\$${tax.toStringAsFixed(2)}'),
                    const Divider(height: 24),
                    _buildSummaryRow(
                      'Total Amount:',
                      '\$${total.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Payment Method
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _paymentMethods.map((method) {
                return _buildPaymentMethodCard(method);
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Payment Form (only show for credit card)
            if (_selectedPaymentMethod == 'credit_card') _buildCreditCardForm(),

            // Other payment method instructions
            if (_selectedPaymentMethod == 'paypal')
              _buildPaymentInstructions(
                'PayPal',
                'You will be redirected to PayPal to complete your payment.',
              ),
            if (_selectedPaymentMethod == 'jazzcash')
              _buildPaymentInstructions(
                'JazzCash',
                'Send payment to JazzCash account 0300-1234567.\n'
                    'Include reference: ST${DateTime.now().millisecondsSinceEpoch}',
              ),
            if (_selectedPaymentMethod == 'easypaisa')
              _buildPaymentInstructions(
                'EasyPaisa',
                'Send payment to EasyPaisa account 0312-3456789.\n'
                    'Include reference: ST${DateTime.now().millisecondsSinceEpoch}',
              ),
            if (_selectedPaymentMethod == 'bank_transfer')
              _buildPaymentInstructions(
                'Bank Transfer',
                'Bank: Silk Track Bank\n'
                    'Account: 1234567890123\n'
                    'IBAN: PK00STBK0000000123456789\n'
                    'Reference: ST${DateTime.now().millisecondsSinceEpoch}',
              ),

            const SizedBox(height: 24),

            // Terms and Conditions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _saveCardInfo,
                  onChanged: (value) {
                    setState(() => _saveCardInfo = value ?? false);
                  },
                ),
                Expanded(
                  child: const Text(
                    'Save card information for future payments',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              'By completing this payment, you agree to our Terms of Service '
              'and Privacy Policy.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 32),

            // Payment Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            // Security Info
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Secure SSL Encryption',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPaymentMethod = method['id']);
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? method['color'].withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? method['color'] : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(method['icon'], size: 30, color: method['color']),
            const SizedBox(height: 8),
            Text(
              method['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: method['color'],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Card Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              maxLength: 19,
              onChanged: (value) {
                // Format card number with spaces
                if (value.length > 0 && value.length % 5 == 0) {
                  if (value[value.length - 1] == ' ') {
                    _cardNumberController.text =
                        value.substring(0, value.length - 1);
                  } else {
                    _cardNumberController.text =
                        '${value.substring(0, value.length - 1)} ${value.substring(value.length - 1)}';
                  }
                  _cardNumberController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _cardNumberController.text.length));
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardHolderController,
              decoration: const InputDecoration(
                labelText: 'Card Holder Name',
                hintText: 'John Doe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    maxLength: 5,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    maxLength: 4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInstructions(String method, String instructions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$method Instructions',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(instructions),
            const SizedBox(height: 16),
            const Text(
              'After making the payment, please email the receipt to payments@silktrack.com',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == 'credit_card') {
      if (_cardNumberController.text.isEmpty ||
          _cardHolderController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all card details'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isProcessing = false);

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Payment Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your enrollment has been confirmed!'),
            const SizedBox(height: 16),
            Text('Program: ${widget.program['title']}'),
            Text('Amount: \$${widget.amount.toStringAsFixed(2)}'),
            Text('Transaction ID: ST${DateTime.now().millisecondsSinceEpoch}'),
            const SizedBox(height: 16),
            const Text(
              'Confirmation email has been sent to your registered email address.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to program detail
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
