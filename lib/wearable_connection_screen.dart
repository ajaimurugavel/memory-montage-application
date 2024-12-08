import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class WearableConnectionScreen extends StatefulWidget {
  const WearableConnectionScreen({super.key});

  @override
  _WearableConnectionScreenState createState() => _WearableConnectionScreenState();
}

class _WearableConnectionScreenState extends State<WearableConnectionScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    // Check if Bluetooth is available on the device
    bool isAvailable = await flutterBlue.isAvailable;
    if (!isAvailable) {
      // Handle Bluetooth not available
      return;
    }

    // Start scanning for devices
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      // Process scan results here, you might want to filter by device name or other criteria
      for (ScanResult result in results) {
        // Assuming you have a specific device you're looking for
        if (result.device.name == 'YourWearableDeviceName') {
          setState(() {
            connectedDevice = result.device;
          });
          break;
        }
      }
    });

    // Optionally, you can also listen to Bluetooth state changes
    flutterBlue.state.listen((BluetoothState state) {
      // Handle Bluetooth state changes here
    });

    // Start scanning
    flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wearable Connection'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.black],
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Realistic watch design
              Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[800],
                ),
                child: Center(
                  child: Container(
                    width: 260.0,
                    height: 260.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Watch bezel
              Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[600]!, width: 8.0),
                ),
              ),
              // Fake time display inside the watch
              const Positioned(
                bottom: 140.0,
                child: Column(
                  children: [
                    Text(
                      '12:00',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 48.0,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'FRI, March 10',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              // Connection status text outside the watch
              Positioned(
                bottom: 16.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: connectedDevice != null ? const Color.fromARGB(255, 86, 240, 72) : Colors.red,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    connectedDevice != null ? 'Connected' : 'Not Connected',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
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
}
