import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/checkout_stepper.dart';
import '../../blocs/checkout/checkout_bloc.dart';
import '../../blocs/checkout/checkout_event.dart';
import '../../blocs/checkout/checkout_state.dart';
import '../../screens/checkout/payment_screen.dart';

class CheckoutShippingScreen extends StatefulWidget {
  const CheckoutShippingScreen({super.key});

  @override
  State<CheckoutShippingScreen> createState() => _CheckoutShippingScreenState();
}

class _CheckoutShippingScreenState extends State<CheckoutShippingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _postalCodeController = TextEditingController();
  String? _selectedProvince;
  String? _selectedCity;
  String _selectedCountry = 'Kenya';

  // Map of African countries with their country codes and flag emojis
  final Map<String, Map<String, String>> _countries = {
    'Kenya': {'code': '+254', 'flag': '🇰🇪'},
    'Nigeria': {'code': '+234', 'flag': '🇳🇬'},
    'South Africa': {'code': '+27', 'flag': '🇿🇦'},
    'Egypt': {'code': '+20', 'flag': '🇪🇬'},
    'Morocco': {'code': '+212', 'flag': '🇲🇦'},
    'Ghana': {'code': '+233', 'flag': '🇬🇭'},
    'Tanzania': {'code': '+255', 'flag': '🇹🇿'},
    'Ethiopia': {'code': '+251', 'flag': '🇪🇹'},
    'Uganda': {'code': '+256', 'flag': '🇺🇬'},
    'Algeria': {'code': '+213', 'flag': '🇩🇿'},
    'Rwanda': {'code': '+250', 'flag': '🇷🇼'},
  };

  // Map of provinces/regions for each country
  final Map<String, List<String>> _provinces = {
    'Kenya': [
      'Nairobi',
      'Coast',
      'Central',
      'Eastern',
      'North Eastern',
      'Nyanza',
      'Rift Valley',
      'Western'
    ],
    'Nigeria': [
      'Lagos',
      'Abuja FCT',
      'Rivers',
      'Kano',
      'Oyo',
      'Delta',
      'Kaduna',
      'Ogun'
    ],
    'South Africa': [
      'Gauteng',
      'Western Cape',
      'KwaZulu-Natal',
      'Eastern Cape',
      'Free State',
      'Mpumalanga',
      'North West',
      'Limpopo',
      'Northern Cape'
    ],
    'Egypt': [
      'Cairo',
      'Alexandria',
      'Giza',
      'Qalyubia',
      'Gharbia',
      'Dakahlia',
      'Sharqia',
      'Beheira'
    ],
    'Morocco': [
      'Casablanca-Settat',
      'Rabat-Salé-Kénitra',
      'Tangier-Tetouan-Al Hoceima',
      'Fès-Meknès',
      'Marrakesh-Safi',
      'Oriental',
      'Béni Mellal-Khénifra'
    ],
    'Rwanda': [
      'Kigali',
      'Butare',
      'Gitarama',
      'Ruhengeri',
      'Gisenyi',
      'Byumba',
      'Cyangugu',
      'Kibuye'
    ]
  };

  // Map of cities for each province
  final Map<String, Map<String, List<String>>> _cities = {
    'Kenya': {
      'Nairobi': ['Nairobi CBD', 'Westlands', 'Karen', 'Eastleigh', 'Kasarani'],
      'Coast': ['Mombasa', 'Malindi', 'Kilifi', 'Lamu', 'Diani'],
      'Central': ['Nyeri', 'Kiambu', 'Thika', 'Muranga', 'Kerugoya'],
      'Eastern': ['Meru', 'Embu', 'Machakos', 'Kitui', 'Isiolo'],
      'North Eastern': ['Garissa', 'Wajir', 'Mandera'],
      'Nyanza': ['Kisumu', 'Homa Bay', 'Kisii', 'Siaya', 'Migori'],
      'Rift Valley': ['Nakuru', 'Eldoret', 'Naivasha', 'Narok', 'Kericho'],
      'Western': ['Kakamega', 'Bungoma', 'Busia', 'Vihiga']
    },
    'Nigeria': {
      'Lagos': ['Lagos Island', 'Victoria Island', 'Ikoyi', 'Lekki', 'Ajah'],
      'Abuja FCT': ['Garki', 'Wuse', 'Maitama', 'Asokoro', 'Gwarinpa'],
      'Rivers': ['Port Harcourt', 'Obio/Akpor', 'Eleme', 'Okrika', 'Bonny'],
      'Kano': ['Kano City', 'Fagge', 'Sabon Gari', 'Bompai', 'Sharada'],
      'Oyo': ['Ibadan', 'Ogbomoso', 'Oyo', 'Iseyin', 'Saki'],
      'Delta': ['Warri', 'Asaba', 'Sapele', 'Ughelli', 'Effurun'],
      'Kaduna': ['Kaduna City', 'Zaria', 'Kafanchan', 'Kachia', 'Kagoro'],
      'Ogun': ['Abeokuta', 'Sagamu', 'Ijebu Ode', 'Ilaro', 'Ota']
    },
    'South Africa': {
      'Gauteng': ['Johannesburg', 'Pretoria', 'Soweto', 'Sandton', 'Boksburg'],
      'Western Cape': [
        'Cape Town',
        'Stellenbosch',
        'Paarl',
        'Strand',
        'Bellville'
      ],
      'KwaZulu-Natal': [
        'Durban',
        'Pietermaritzburg',
        'Umhlanga',
        'Ballito',
        'Pinetown'
      ],
      'Eastern Cape': [
        'Port Elizabeth',
        'East London',
        'Uitenhage',
        'Queenstown',
        'Grahamstown'
      ],
      'Free State': [
        'Bloemfontein',
        'Welkom',
        'Kroonstad',
        'Bethlehem',
        'Sasolburg'
      ],
      'Mpumalanga': ['Nelspruit', 'Witbank', 'Secunda', 'Standerton', 'Bethal'],
      'North West': [
        'Rustenburg',
        'Potchefstroom',
        'Klerksdorp',
        'Mahikeng',
        'Brits'
      ],
      'Limpopo': [
        'Polokwane',
        'Tzaneen',
        'Phalaborwa',
        'Louis Trichardt',
        'Mokopane'
      ],
      'Northern Cape': [
        'Kimberley',
        'Upington',
        'Springbok',
        'De Aar',
        'Kuruman'
      ]
    },
    'Egypt': {
      'Cairo': [
        'Downtown Cairo',
        'Maadi',
        'Heliopolis',
        'Zamalek',
        'New Cairo'
      ],
      'Alexandria': [
        'Downtown Alexandria',
        'Stanley',
        'Sidi Gaber',
        'Smouha',
        'Miami'
      ],
      'Giza': ['Giza City', 'Dokki', 'Mohandessin', 'Agouza', 'Haram'],
      'Qalyubia': ['Banha', 'Qalyub', 'Shubra El Kheima', 'Khanka', 'Qaha'],
      'Gharbia': [
        'Tanta',
        'Mahalla El Kubra',
        'Kafr El-Zayat',
        'Zefta',
        'Basyoun'
      ],
      'Dakahlia': ['Mansoura', 'Talkha', 'Aga', 'Mit Ghamr', 'Belqas'],
      'Sharqia': [
        'Zagazig',
        '10th of Ramadan City',
        'Bilbeis',
        'Abu Hammad',
        'Faqous'
      ],
      'Beheira': [
        'Damanhour',
        'Kafr El-Dawwar',
        'Rashid',
        'Edku',
        'Abu El-Matamir'
      ]
    },
    'Morocco': {
      'Casablanca-Settat': [
        'Casablanca',
        'Mohammedia',
        'Benslimane',
        'Settat',
        'El Jadida'
      ],
      'Rabat-Salé-Kénitra': ['Rabat', 'Salé', 'Kénitra', 'Skhirate', 'Témara'],
      'Tangier-Tetouan-Al Hoceima': [
        'Tangier',
        'Tetouan',
        'Al Hoceima',
        'Larache',
        'Fahs-Anjra'
      ],
      'Fès-Meknès': ['Fès', 'Meknès', 'Sefrou', 'Moulay Yacoub', 'Ifrane'],
      'Marrakesh-Safi': [
        'Marrakesh',
        'Safi',
        'El Kelaa des Sraghna',
        'Essaouira',
        'Chichaoua'
      ],
      'Oriental': ['Oujda', 'Nador', 'Berkane', 'Taourirt', 'Guercif'],
      'Béni Mellal-Khénifra': [
        'Béni Mellal',
        'Khouribga',
        'Fquih Ben Salah',
        'Azilal',
        'Khenifra'
      ]
    },
    'Rwanda': {
      'Kigali': [
        'Kigali City',
        'Kimihurura',
        'Nyarugenge',
        'Gasabo',
        'Kicukiro'
      ],
      'Butare': ['Butare City', 'Huye', 'Nyanza', 'Gisagara', 'Nyaruguru'],
      'Gitarama': [
        'Gitarama City',
        'Muhanga',
        'Ruhango',
        'Kamonyi',
        'Ngororero'
      ],
      'Ruhengeri': [
        'Ruhengeri City',
        'Musanze',
        'Burera',
        'Gakenke',
        'Rulindo'
      ],
      'Gisenyi': ['Gisenyi City', 'Rubavu', 'Rutsiro', 'Nyabihu', 'Ngororero'],
      'Byumba': ['Byumba City', 'Gicumbi', 'Rulindo', 'Burera', 'Gakenke'],
      'Cyangugu': [
        'Cyangugu City',
        'Rusizi',
        'Nyamasheke',
        'Karongi',
        'Rutsiro'
      ],
      'Kibuye': ['Kibuye City', 'Karongi', 'Rutsiro', 'Rubavu', 'Nyabihu']
    }
  };

  @override
  Widget build(BuildContext context) {
    final provinces = _provinces[_selectedCountry] ?? [];
    final cities = _selectedProvince != null
        ? (_cities[_selectedCountry]?[_selectedProvince] ?? [])
        : [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Shipping',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const CheckoutStepper(currentStep: 0),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
              items: _countries.keys
                  .map<DropdownMenuItem<String>>((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text('${_countries[country]!['flag']} $country'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCountry = newValue!;
                  _selectedProvince = null;
                  _selectedCity = null;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedProvince,
              decoration: const InputDecoration(
                labelText: 'Province/State',
                border: OutlineInputBorder(),
              ),
              items: provinces.map<DropdownMenuItem<String>>((String province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(province),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProvince = newValue;
                  _selectedCity = null;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a province';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: cities.map<DropdownMenuItem<String>>((dynamic city) {
                return DropdownMenuItem<String>(
                  value: city.toString(),
                  child: Text(city.toString()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a city';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(
                labelText: 'Street Address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your street address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(
                labelText: 'Postal Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your postal code';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Create shipping address
                  final shippingAddress = ShippingAddress(
                    fullName: _nameController.text,
                    phoneNumber: _phoneController.text,
                    streetAddress: _streetController.text,
                    province: _selectedProvince!,
                    city: _selectedCity!,
                    postalCode: _postalCodeController.text,
                  );

                  // Update shipping address in checkout bloc
                  context
                      .read<CheckoutBloc>()
                      .add(UpdateShippingAddress(shippingAddress));

                  // Navigate to payment screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutPaymentScreen(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
