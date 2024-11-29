import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class Ip extends StatefulWidget {
  const Ip({super.key});

  @override
  State<Ip> createState() => _IpState();
}

class _IpState extends State<Ip> {
  String _ipAddress = "Unknown";

  @override
  void initState() {
    super.initState();
    _getIpAddress();
  }

  Future<void> _getIpAddress() async {
    final info = NetworkInfo();
    try {
      final ip = await info.getWifiName();
      setState(() {
        _ipAddress = ip ?? "Failed to get IP Address.";
      });
    } catch (e) {
      setState(() {
        _ipAddress = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device IP Address'),
      ),
      body: Center(
        child: Text(
          _ipAddress,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

