import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import '../service/battery_service.dart';

class ResourceUsageScreen extends StatefulWidget {
  const ResourceUsageScreen({Key? key}) : super(key: key);

  @override
  _ResourceUsageScreenState createState() => _ResourceUsageScreenState();
}

class _ResourceUsageScreenState extends State<ResourceUsageScreen> {
  static const platform =
      MethodChannel('com.example.project_jelly/resourceUsage');

  String _batteryUsage = 'Unknown';
  String _memoryUsage = 'Unknown';
  String _cpuUsage = 'Unknown';
  final BatteryService _batteryService = Get.find<BatteryService>();

  @override
  void initState() {
    super.initState();
    _batteryService.init().then((_) {
      setState(() {
        _batteryUsage = '${_batteryService.batteryLevel}%';
      });
    });
    getResourceUsage();
  }

  Future<void> getResourceUsage() async {
    String batteryUsage;
    String memoryUsage;
    String cpuUsage;
    try {
      batteryUsage = '${_batteryService.batteryLevel}%';

      final result = await platform.invokeMethod('getResourceUsage');
      memoryUsage = result['memoryUsage'];
      cpuUsage = result['cpuUsage'];
    } on PlatformException catch (e) {
      batteryUsage = "Failed to get battery usage: '${e.message}'.";
      memoryUsage = "Failed to get memory usage: '${e.message}'.";
      cpuUsage = "Failed to get CPU usage: '${e.message}'.";
    }

    setState(() {
      _batteryUsage = batteryUsage;
      _memoryUsage = memoryUsage;
      _cpuUsage = cpuUsage;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      ResourceInfoCard(
        title: 'Battery level',
        value: _batteryUsage,
        icon: Icons.battery_full,
      ),
    ];

    if (Platform.isAndroid) {
      widgets.addAll([
        SizedBox(height: 16),
        ResourceInfoCard(
          title: 'Memory usage',
          value: _memoryUsage,
          icon: Icons.memory,
        ),
        SizedBox(height: 16),
        ResourceInfoCard(
          title: 'CPU usage',
          value: _cpuUsage,
          icon: Icons.speed,
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Resource Usage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Resource Usage Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
            ...widgets,
          ],
        ),
      ),
    );
  }
}

class ResourceInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ResourceInfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4.0,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          child: Align(
            alignment: Alignment.center,
            child: Icon(icon, size: 24),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(value),
      ),
    );
  }
}
