// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker

enum FlashState { off, photoOnly, torch }

class CameraOverlayPage extends StatefulWidget {
  final CameraDescription camera;
  final Function(XFile) onPictureTaken;

  const CameraOverlayPage({Key? key, required this.camera, required this.onPictureTaken}) : super(key: key);

  @override
  _CameraOverlayPageState createState() => _CameraOverlayPageState();
}

class _CameraOverlayPageState extends State<CameraOverlayPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  FlashState _flashState = FlashState.off;

  Offset? _focusPoint;
  bool _showFocusCircle = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    _controller.setFlashMode(FlashMode.off);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _flashIcon() {
    switch (_flashState) {
      case FlashState.off:
        return Icons.flash_off;
      case FlashState.photoOnly:
        return Icons.flash_auto;
      case FlashState.torch:
        return Icons.flash_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturar Imágen'),
        actions: [
          IconButton(
            icon: Icon(_flashIcon()),
            onPressed: () async {
              try {
                switch (_flashState) {
                  case FlashState.off:
                    _flashState = FlashState.photoOnly;
                    break;
                  case FlashState.photoOnly:
                    await _controller.setFlashMode(FlashMode.torch);
                    _flashState = FlashState.torch;
                    break;
                  case FlashState.torch:
                    await _controller.setFlashMode(FlashMode.off);
                    _flashState = FlashState.off;
                    break;
                }
                setState(() {}); 
              } catch (e) {
                print('Error toggling flash: $e');
              }
            },
          ),
          // New Gallery Access Button
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () async {
              try {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  widget.onPictureTaken(image);
                  Navigator.pop(context);
                }
              } catch (e) {
                print('Error picking image from gallery: $e');
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                GestureDetector(
                  onTapDown: (TapDownDetails details) async {
                    try {
                      final RenderBox box = context.findRenderObject() as RenderBox;
                      final Offset localOffset = box.globalToLocal(details.globalPosition);
                      final Size size = box.size;
                      final double dx = localOffset.dx / size.width;
                      final double dy = localOffset.dy / size.height;
                      await _controller.setFocusPoint(Offset(dx, dy));

                      setState(() {
                        _focusPoint = localOffset;
                        _showFocusCircle = true;
                      });

                      Future.delayed(const Duration(milliseconds: 500), () {
                        setState(() {
                          _showFocusCircle = false;
                        });
                      });
                    } catch (e) {
                      print('Error setting focus: $e');
                    }
                  },
                  child: CameraPreview(_controller),
                ),
                Center(
                  child: Container(
                    width: 350,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 3.0,
                      ),
                    ),
                  ),
                ),
                if (_showFocusCircle && _focusPoint != null)
                  Positioned(
                    left: _focusPoint!.dx - 20,
                    top: _focusPoint!.dy - 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(255, 248, 248, 238), width: 2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            if (_flashState == FlashState.photoOnly) {
              await _controller.setFlashMode(FlashMode.always);
            }
            final image = await _controller.takePicture();
            widget.onPictureTaken(image);
            if (_flashState == FlashState.photoOnly) {
              await _controller.setFlashMode(FlashMode.off);
            }
            Navigator.pop(context);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
