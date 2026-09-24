// core Flutter primitives
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

// Passes incoming FCM messages from the event handler to the UI.
final _messageStreamController = BehaviorSubject<RemoteMessage>();

// Background message handler must be a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;

  // Request permission to show notifications.
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  String? token;
  if (kIsWeb) {
    const vapidKey = 'BPgu3rKWY1M27RHb4bCs-ZTPaGp0vA0Uf1twmNdS59wnlqvkel3ENDqNRNDYPlcNrfqiPmLJnluR9sjR5r8HbjU';
    token = await messaging.getToken(vapidKey: vapidKey);
  } else {
    token = await messaging.getToken();
  }

  if (kDebugMode) {
    print('Registration Token=$token');
  }

  // Foreground message handler.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    _messageStreamController.sink.add(message);
  });

  // Background message handler.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // subscribeToTopic() isn't supported on web — only call it on other platforms.
  if (!kIsWeb) {
    const topic = 'app_promotion';
    await messaging.subscribeToTopic(topic);
  }

  runApp(const ZodiacApp());
}

class ZodiacApp extends StatelessWidget {
  const ZodiacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Signs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B1F),
      ),
      home: const ZodiacPage(),
    );
  }
}

class ZodiacSign {
  final String name;
  final String symbol;
  final String dateRange;
  final String element;
  final List<Color> colors;

  const ZodiacSign(
    this.name,
    this.symbol,
    this.dateRange,
    this.element,
    this.colors,
  );
}

const List<ZodiacSign> zodiacSigns = [
  ZodiacSign('Aries', '♈', 'Mar 21 – Apr 19', 'Fire',
      [Color(0xFFFF512F), Color(0xFFDD2476)]),
  ZodiacSign('Taurus', '♉', 'Apr 20 – May 20', 'Earth',
      [Color(0xFF56AB2F), Color(0xFFA8E063)]),
  ZodiacSign('Gemini', '♊', 'May 21 – Jun 20', 'Air',
      [Color(0xFFFFD200), Color(0xFFF7971E)]),
  ZodiacSign('Cancer', '♋', 'Jun 21 – Jul 22', 'Water',
      [Color(0xFF396AFC), Color(0xFF2948FF)]),
  ZodiacSign('Leo', '♌', 'Jul 23 – Aug 22', 'Fire',
      [Color(0xFFF7971E), Color(0xFFFFD200)]),
  ZodiacSign('Virgo', '♍', 'Aug 23 – Sep 22', 'Earth',
      [Color(0xFF11998E), Color(0xFF38EF7D)]),
  ZodiacSign('Libra', '♎', 'Sep 23 – Oct 22', 'Air',
      [Color(0xFFFC5C7D), Color(0xFF6A82FB)]),
  ZodiacSign('Scorpio', '♏', 'Oct 23 – Nov 21', 'Water',
      [Color(0xFF360033), Color(0xFF0B8793)]),
  ZodiacSign('Sagittarius', '♐', 'Nov 22 – Dec 21', 'Fire',
      [Color(0xFFB92B27), Color(0xFF1565C0)]),
  ZodiacSign('Capricorn', '♑', 'Dec 22 – Jan 19', 'Earth',
      [Color(0xFF232526), Color(0xFF414345)]),
  ZodiacSign('Aquarius', '♒', 'Jan 20 – Feb 18', 'Air',
      [Color(0xFF00C6FF), Color(0xFF0072FF)]),
  ZodiacSign('Pisces', '♓', 'Feb 19 – Mar 20', 'Water',
      [Color(0xFF7F00FF), Color(0xFFE100FF)]),
];

// Returns the zodiac sign for a given month/day.
ZodiacSign signForDate(int month, int day) {
  const boundaries = [
    [3, 21], [4, 20], [5, 21], [6, 21], [7, 23], [8, 23],
    [9, 23], [10, 23], [11, 22], [12, 22], [1, 20], [2, 19],
  ];
  for (int i = 0; i < boundaries.length; i++) {
    final start = boundaries[i];
    final end = boundaries[(i + 1) % boundaries.length];
    final afterStart = (month == start[0] && day >= start[1]) ||
        (month == start[0] + 1 && day < end[1]) ||
        (start[0] == 12 && month == 1 && day < end[1]);
    if (afterStart) return zodiacSigns[i];
  }
  return zodiacSigns[0];
}

class ZodiacPage extends StatefulWidget {
  const ZodiacPage({super.key});

  @override
  State<ZodiacPage> createState() => _ZodiacPageState();
}

class _ZodiacPageState extends State<ZodiacPage> {
  DateTime? _pickedDate;
  String _lastMessage = '';

  _ZodiacPageState() {
    // Listen for incoming FCM messages and surface the latest one in the UI.
    _messageStreamController.listen((message) {
      setState(() {
        if (message.notification != null) {
          _lastMessage = 'Received a notification:'
              '\nTitle=${message.notification?.title},'
              '\nBody=${message.notification?.body}';
        } else {
          _lastMessage = 'Received a data message: ${message.data}';
        }
      });
    });
  }

  ZodiacSign? get _resultSign => _pickedDate == null
      ? null
      : signForDate(_pickedDate!.month, _pickedDate!.day);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, 12, 31),
      helpText: 'Pick your birthday',
    );
    if (picked != null) {
      setState(() => _pickedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Star Signs'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.white.withOpacity(0.06),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Find your sign',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.cake_outlined),
                      label: Text(
                        _pickedDate == null
                            ? 'Pick your birthday'
                            : '${_pickedDate!.month}/${_pickedDate!.day}/${_pickedDate!.year}',
                      ),
                    ),
                    if (_resultSign != null) ...[
                      const SizedBox(height: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            colors: _resultSign!.colors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _resultSign!.symbol,
                              style: const TextStyle(fontSize: 40),
                            ),
                            Text(
                              _resultSign!.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${_resultSign!.dateRange} • ${_resultSign!.element}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (_lastMessage.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        _lastMessage,
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'All signs',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: zodiacSigns.length,
              itemBuilder: (context, index) {
                final sign = zodiacSigns[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: sign.colors,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ListTile(
                    leading: Text(
                      sign.symbol,
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    title: Text(
                      sign.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${sign.dateRange} • ${sign.element}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}