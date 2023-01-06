import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

import '_commonLIb.dart';
import '_qrCodeScanner.dart';

const String appTitle = '동행 v2 (기사님용) 프로토타입 v0.1.1';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.bus_alert),
              label: const Text("운행 시작"),
              onPressed: ()  {
                final player = AudioPlayer();
                player.setAsset('/audio/ddiring.wav');
                player.setVolume(1);
                player.play();

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const QRViewExample(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// QR 촬영을 위해 카메라와 저장소 권한 획득 여부를 확인 및 요청
Future<bool> checkCamaraPermission() async {
  bool bPerm = false;

  // 카메라와 저장소 권한 요청
  Map<Permission, PermissionStatus> permStatMap = await [
    Permission.camera,
    Permission.storage,
  ].request();

  print(permStatMap[Permission.camera]);
  print(permStatMap[Permission.storage]);

  // 카메라와 저장소 권한을 획득한 상태이면..
  // ? : nullable
  // ! : 절대 null은 리턴되지 않는다고 명시
  if (permStatMap[Permission.camera]!.isGranted && permStatMap[Permission.storage]!.isGranted) {
    bPerm = true;
  } else {
    openAppSettings();
  }

  return bPerm;
}

