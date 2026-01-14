// custom_video_player.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final dynamic videoFile;
  final BoxFit fit;
  final bool autoPlay;
  final bool loop;

  const CustomVideoPlayer({
    super.key,
    required this.videoFile,
    this.fit = BoxFit.cover,
    this.autoPlay = false,
    this.loop = false,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final isRemote = widget.videoFile is String;
      _controller =
          isRemote
              ? VideoPlayerController.networkUrl(Uri.parse(widget.videoFile))
              : VideoPlayerController.file(widget.videoFile as File);

      await _controller!.initialize();
      _controller!.setLooping(widget.loop);

      if (widget.autoPlay) {
        _controller!.play();
        _isPlaying = true;
      }

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur initialisation vidéo : $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isInitialized || _controller == null) {
      return const Center(child: Icon(Icons.error, color: Colors.red));
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          if (!_isPlaying)
            Container(
              color: Colors.black26,
              child: const Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 64,
              ),
            ),
        ],
      ),
    );
  }
}
