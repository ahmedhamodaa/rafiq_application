import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  int? _selectedPaymentIndex;

  // Payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Instapay', 'image': 'images/payment/instaPay_logo.webp'},
    {
      'name': 'Credit or Debit Card',
      'image': 'images/payment/Visa_Mastercard.webp'
    },
    {'name': 'E-Wallet', 'image': 'images/payment/wallet.png'},
  ];

  // Titles for each step
  final List<String> _titles = [
    'Booking Details',
    'Payment Info',
    'Confirmation',
  ];

  void _onContinue() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Handle payment action here
      debugPrint('Payment completed!');
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildPaymentInfoForm() {
    if (_selectedPaymentIndex == 0 || _selectedPaymentIndex == 2) {
      // Instapay or E-Wallet
      return const Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      );
    } else if (_selectedPaymentIndex == 1) {
      // Credit or Debit Card
      return const Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Expiration Date (MM/YY)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentStep]),
        centerTitle: true,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _onBack,
              )
            : null,
      ),
      body: Column(
        children: [
          // Progress Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: _currentStep >= index
                          ? const Color(0xff071952)
                          : Colors.grey[300],
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: _currentStep >= index
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                    if (index != 2)
                      Container(
                        width: 112,
                        height: 2,
                        color: _currentStep > index
                            ? const Color(0xff071952)
                            : Colors.grey[300],
                      ),
                  ],
                );
              }),
            ),
          ),
          // PageView for Screens
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Screen 1: Payment Method Selection
                Column(
                  children: [
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Text(
                            'Choose your payment method:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: RadioGroup<int>(
                        groupValue: _selectedPaymentIndex,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedPaymentIndex = value;
                          });
                        },
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _paymentMethods.length,
                          itemBuilder: (context, index) {
                            final method = _paymentMethods[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 8),
                              child: ListTile(
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                      color: Color(0xff071952)),
                                ),
                                leading: Image.asset(
                                  method['image'],
                                  height: 36,
                                  width: 44,
                                ),
                                title: Text(method['name']),
                                trailing: Radio<int>(
                                  activeColor: const Color(0xff071952),
                                  value: index,
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentIndex = index;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed:
                            _selectedPaymentIndex != null ? _onContinue : null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                          foregroundColor: _selectedPaymentIndex != null
                              ? Colors.white
                              : Colors.black54,
                          backgroundColor: _selectedPaymentIndex != null
                              ? const Color(0xff071952)
                              : Colors.grey,
                        ),
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
                // Screen 2: Payment Info
                Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildPaymentInfoForm(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _onContinue,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff071952),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
                // Screen 3: Confirmation
                Column(
                  children: [
                    Expanded(
                      child: Center(
                          child: Container(
                        height: 320,
                        width: 368,
                        decoration: BoxDecoration(
                            color: const Color(0xff071952),
                            borderRadius: BorderRadius.circular(16)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 24.0, horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'AI Diploma',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '6000 EGP',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Instructor Ahmed at Netriders.Academy',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 8),
                              Divider(color: Colors.white),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_sharp,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            ' Time',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '120 h',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person_add_alt_1_outlined,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            ' Booked',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '+150 Students',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(color: Colors.white),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Total: ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '6000 EGP',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _onContinue,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff071952),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Pay Now'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
