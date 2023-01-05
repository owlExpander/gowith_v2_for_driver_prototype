import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = '동행 v2 기사님용 (프로토타입)';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: Center(
          child: ElevatedButton.icon(
            onPressed: () async {
              // You can request multiple permissions at once.
              Map<Permission, PermissionStatus> statuses = await [
                Permission.camera,
                Permission.storage,
              ].request();
              print(statuses[Permission.location]);
            },
            icon: Icon(Icons.bus_alert),
            label: Text("운행 시작"),
          ),
        ),
      ),
    );
  }
}