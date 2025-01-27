// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lamundialapp/pages/rolPage.dart';
import 'package:video_player/video_player.dart';

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Inicializar el controlador del video y silenciarlo
    _controller = VideoPlayerController.asset('assets/videos/Lamundial.mp4')
      ..initialize().then((_) {
        setState(() {}); // Actualizar el estado cuando el video esté listo
        _controller.setVolume(0.0); // Silenciar el video
        _controller.play(); // Iniciar la reproducción automáticamente
      });

    // Programar la navegación a la página principal después de 9 segundos
    Future.delayed(const Duration(seconds: 9), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RolPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Liberar el controlador cuando el widget se destruya
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? Center(
              child: Transform.scale(
                scale: 1.6, // Escala del 60% más grande
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(), // Pantalla en blanco mientras se inicializa el video
    );
  }
}
