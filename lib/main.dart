import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const WeatherDemoApp());

class WeatherDemoApp extends StatefulWidget {
  const WeatherDemoApp({super.key});
  @override
  State<WeatherDemoApp> createState() => _WeatherDemoAppState();
}

class _WeatherDemoAppState extends State<WeatherDemoApp> {
  static const _kIsDark = 'settings.isDark';
  static const _kFontSize = 'settings.fontSize';

  bool _isDark = false;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isDark = prefs.getBool(_kIsDark) ?? false;
        _fontSize = prefs.getDouble(_kFontSize) ?? 16.0;
      });
    } catch (e) {
      debugPrint('Load prefs error: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kIsDark, _isDark);
      await prefs.setDouble(_kFontSize, _fontSize);
    } catch (e) {
      debugPrint('Save prefs error: $e');
    }
  }

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
    _saveSettings();
  }

  void _updateFontSize(double v) {
    setState(() => _fontSize = v);
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDark
        ? ThemeData.dark().copyWith(
            primaryColor: Colors.teal,
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.teal,
            ),
          )
        : ThemeData(
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: const Color(0xFFF4F6F8),
          );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dự báo thời tiết (Demo)',
      theme: theme,
      home: HomePage(
        isDark: _isDark,
        fontSize: _fontSize,
        onThemeToggle: _toggleTheme,
        onFontSizeChanged: _updateFontSize,
      ),
    );
  }
}

class Hourly {
  final String time;
  final int temp;
  final IconData icon;
  const Hourly(this.time, this.temp, this.icon);
}

class HomePage extends StatelessWidget {
  final bool isDark;
  final double fontSize;
  final VoidCallback onThemeToggle;
  final ValueChanged<double> onFontSizeChanged;

  const HomePage({
    super.key,
    required this.isDark,
    required this.fontSize,
    required this.onThemeToggle,
    required this.onFontSizeChanged,
  });

  List<Hourly> get _hoursFull => const [
    Hourly("Bây giờ", 30, Icons.cloud),
    Hourly("9:00", 31, Icons.wb_sunny),
    Hourly("10:00", 32, Icons.wb_sunny),
    Hourly("11:00", 33, Icons.wb_cloudy),
    Hourly("12:00", 33, Icons.wb_sunny_outlined),
    Hourly("13:00", 34, Icons.cloud),
    Hourly("14:00", 33, Icons.wb_sunny),
    Hourly("15:00", 32, Icons.wb_cloudy),
    Hourly("16:00", 31, Icons.cloud),
    Hourly("17:00", 30, Icons.nights_stay),
    Hourly("18:00", 29, Icons.nightlight),
    Hourly("19:00", 28, Icons.nightlight_round),
  ];

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final iconColor = isDark ? Colors.tealAccent : Colors.teal;
    const double hourlyTimeSize = 13;
    const double hourlyTempSize = 18;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dự báo thời tiết"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Cài đặt",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text("Chế độ tối"),
                secondary: const Icon(Icons.brightness_6, color: Colors.teal),
                value: isDark,
                onChanged: (_) => onThemeToggle(),
              ),
              ListTile(
                title: const Text("Kích thước chữ"),
                subtitle: Slider(
                  value: fontSize,
                  min: 12,
                  max: 26,
                  divisions: 7,
                  label: '${fontSize.toInt()}',
                  activeColor: Colors.teal,
                  onChanged: onFontSizeChanged,
                ),
              ),
              const Divider(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Địa điểm",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const ListTile(
                title: Text("Đà Nẵng"),
                subtitle: Text("Việt Nam"),
              ),
              const ListTile(title: Text("Hà Nội"), subtitle: Text("Việt Nam")),
              const ListTile(
                title: Text("Hồ Chí Minh"),
                subtitle: Text("Việt Nam"),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Text(
                      "VỊ TRÍ CỦA TÔI",
                      style: TextStyle(
                        fontSize: (fontSize - 2).clamp(12, 20),
                        color: Colors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud, size: 38, color: iconColor),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Đà Nẵng",
                              style: TextStyle(
                                fontSize: (fontSize + 12).clamp(20, 40),
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Mưa nhẹ",
                              style: TextStyle(
                                fontSize: (fontSize - 2).clamp(12, 18),
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "30°C",
                      style: TextStyle(
                        fontSize: (fontSize * 3).clamp(36, 80),
                        fontWeight: FontWeight.w300,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Dự báo 12 giờ tới",
              style: TextStyle(
                fontSize: (fontSize + 1).clamp(14, 22),
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _hoursFull.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final h = _hoursFull[i];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            h.time,
                            style: const TextStyle(
                              fontSize: hourlyTimeSize,
                              color: Colors.grey,
                            ),
                          ),
                          Icon(h.icon, size: 28, color: iconColor),
                          Text(
                            "${h.temp}°",
                            style: const TextStyle(
                              fontSize: hourlyTempSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal.shade200,
        foregroundColor: Colors.teal.shade900,
        icon: const Icon(Icons.refresh),
        label: const Text("Làm mới"),
        onPressed: () {},
      ),
    );
  }
}
