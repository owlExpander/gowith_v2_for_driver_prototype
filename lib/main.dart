import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:location/location.dart';

import '_commonLIb.dart';
import '_qrCodeScanner.dart';

const String appTitle = '동행 v2 (기사님용) 프로토타입 v0.1.3';

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
  late double? lat;
  late double? lng;
  int nCheckCnt = 0;
  late String strLat = '';
  late String strLng = '';
  Location location = Location();

  @override
  void initState() {
    super.initState();

    _locateMe(); // 최초 1회 실행
    Timer.periodic(Duration(seconds: 5), (timer) {  // 일정 시간 간격으로 반복
      _locateMe();
    });
  }

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
              icon: const Icon(Icons.bus_alert, size: 50),
              label: const Text("운행 시작"),
              style: ElevatedButton.styleFrom(minimumSize: const Size(300, 100), textStyle: const TextStyle(fontSize: 50)),
              onPressed: ()  {
                final player = AudioPlayer();
                player.setAsset('/audio/ddiring.mp3');
                player.setVolume(1);
                player.play();

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const QRViewExample(),
                ));
              },
            ),
            const SizedBox(height: 50,),
            Text('$nCheckCnt회 위치 조회'),
            Text(strLat),
            Text(strLng),
          ],
        ),
      ),
    );
  }

  /// 현재 위치 조회
  _locateMe() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.getLocation().then((res) {
      setState(() {
        lat = res.latitude;
        lng = res.longitude;

        if (lat != null) {
          nCheckCnt++;
          strLat = '현재 위도 : $lat';
          strLng = '현재 경도 : $lng';
        }
      });
    });
  }
}