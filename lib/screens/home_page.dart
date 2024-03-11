import 'dart:convert';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  String price = "";
  List<double> data = [];

  wsfunc() async {
    final wsUrl = Uri.parse('wss://stream.binance.com:9443/ws/etheur@trade');
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;

    channel.stream.listen((message) {
      Map val = json.decode(message);
      name = val['s'];
      price = val['p'];
      data.add(double.tryParse(price) ?? 0.0);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    wsfunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Center(
          child: Text(
            "WebSocket Binance",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Container(
        color: Colors.deepPurple,

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                price,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color:Colors.pinkAccent ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Sparkline(
                  data: data,
                  gridLinelabelPrefix: '\$',
                  gridLineLabelPrecision: 3,
                  enableGridLines: true,
                  useCubicSmoothing: true,
                  cubicSmoothingFactor: 0.2,
                  lineWidth: 3.0,
                  lineGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purple[800]!, Colors.purple[200]!],
                  ),
                  fillMode: FillMode.below,
                  fillGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.pink[800]!, Colors.pink[200]!],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
