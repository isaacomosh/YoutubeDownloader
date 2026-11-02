import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/download_provider.dart';
import './screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DownloadProvider())],
      child: const YoutubeDownloaderApp(),
    ),
  );
}

class YoutubeDownloaderApp extends StatelessWidget {
  const YoutubeDownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Downloader',
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
