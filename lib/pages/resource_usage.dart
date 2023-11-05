import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResourceUsageScreen extends StatefulWidget {
  const ResourceUsageScreen({Key? key}) : super(key: key);
  @override
  _ResourceUsageScreenState createState() => _ResourceUsageScreenState();
}

class _ResourceUsageScreenState extends State<ResourceUsageScreen> {
  static const platform = const MethodChannel('com.example.project_jelly/resourceUsage');

  String _batteryUsage = 'Unknown';
  String _memoryUsage = 'Unknown';
  String _cpuUsage = 'Unknown';

  @override
  void initState() {
    super.initState();
    getResourceUsage();
  }

  Future<void> getResourceUsage() async {
    String batteryUsage;
    String memoryUsage;
    String cpuUsage;
    try {
      final result = await platform.invokeMethod('getResourceUsage');
      batteryUsage = result['batteryUsage'];
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Resource Usage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Battery usage over last hour: $_batteryUsage'),
            Text('Memory usage: $_memoryUsage'),
            Text('CPU usage: $_cpuUsage'),
          ],
        ),
      ),
    );
  }
}
