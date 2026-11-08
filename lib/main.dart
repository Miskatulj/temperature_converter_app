import 'package:flutter/material.dart';

void main() => runApp(const TemperatureConverterApp());

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF1565C0);
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF90CAF9)),
          ),
          filled: true,
          fillColor: const Color(0xFFF8FBFF),
        ),
      ),
      home: const TemperatureConverterPage(),
    );
  }
}

enum ConversionType { celsiusToFahrenheit, fahrenheitToCelsius }

class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({super.key});

  @override
  State<TemperatureConverterPage> createState() =>
      _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  final TextEditingController _temperatureController = TextEditingController();
  ConversionType _conversionType = ConversionType.celsiusToFahrenheit;
  String? _errorText;
  double? _result;

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  void _convertTemperature() {
    final input = _temperatureController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _errorText = 'Please enter a temperature.';
        _result = null;
      });
      return;
    }

    final temperature = double.tryParse(input);
    if (temperature == null) {
      setState(() {
        _errorText = 'Please enter a valid number.';
        _result = null;
      });
      return;
    }

    setState(() {
      _errorText = null;
      // Apply the formula associated with the selected conversion direction.
      _result = _conversionType == ConversionType.celsiusToFahrenheit
          ? (temperature * 9 / 5) + 32
          : (temperature - 32) * 5 / 9;
    });
  }

  String get _inputUnit =>
      _conversionType == ConversionType.celsiusToFahrenheit ? '°C' : '°F';

  String get _outputUnit =>
      _conversionType == ConversionType.celsiusToFahrenheit ? '°F' : '°C';

  String get _conversionLabel =>
      _conversionType == ConversionType.celsiusToFahrenheit
      ? 'Celsius to Fahrenheit (°C → °F)'
      : 'Fahrenheit to Celsius (°F → °C)';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isNarrowScreen = MediaQuery.sizeOf(context).width < 380;
    final horizontalPadding = isNarrowScreen ? 16.0 : 24.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 1,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.thermostat_rounded,
                        size: 52,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Convert temperatures with ease',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _temperatureController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _convertTemperature(),
                        decoration: InputDecoration(
                          labelText: 'Temperature',
                          hintText: 'Enter a value in $_inputUnit',
                          prefixIcon: const Icon(Icons.numbers_rounded),
                          suffixText: _inputUnit,
                          errorText: _errorText,
                        ),
                      ),
                      const SizedBox(height: 18),
                      DropdownButtonFormField<ConversionType>(
                        value: _conversionType,
                        isExpanded: true,
                        isDense: true,
                        decoration: const InputDecoration(
                          labelText: 'Conversion type',
                          prefixIcon: Icon(Icons.swap_horiz_rounded),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: ConversionType.celsiusToFahrenheit,
                            child: Text(
                              'Celsius to Fahrenheit (°C → °F)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem(
                            value: ConversionType.fahrenheitToCelsius,
                            child: Text(
                              'Fahrenheit to Celsius (°F → °C)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _conversionType = value;
                              _result = null;
                              _errorText = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _convertTemperature,
                        icon: const Icon(Icons.calculate_rounded),
                        label: const Text('Convert'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      if (_result != null) ...[
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text('RESULT', style: theme.textTheme.labelLarge),
                              const SizedBox(height: 8),
                              Text(
                                '${_result!.toStringAsFixed(2)} $_outputUnit',
                                key: const Key('conversionResult'),
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _conversionLabel,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
