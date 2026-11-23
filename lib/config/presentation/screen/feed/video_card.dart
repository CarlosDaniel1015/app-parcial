import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:app_parcial/models/video_item_model.dart';

class VideoCard extends StatefulWidget {
  final VideoItemModel video;
  final bool isVisible;

  const VideoCard({
    super.key,
    required this.video,
    required this.isVisible,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showPlayPauseOverlay = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final uri = Uri.parse(widget.video.videoUrl);
      _controller = VideoPlayerController.networkUrl(uri);
      await _controller!.initialize();
      _controller!.setLooping(true);

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });

        if (widget.isVisible) {
          _controller!.play();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant VideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller == null || !_isInitialized) return;

    if (widget.isVisible && !oldWidget.isVisible) {
      _controller!.play();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller!.pause();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      _showPlayPauseOverlay = true;
    });

    _animController.forward(from: 0.0).then((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _showPlayPauseOverlay = false;
          });
        }
      });
    });
  }

  void _onDoubleTap() {
    if (!widget.video.isLiked) {
      setState(() {
        widget.video.isLiked = true;
        widget.video.likes++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      onDoubleTap: _onDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Capa de Fondo / Video
          _buildVideoPlayer(),

          // Gradiente inferior para legibilidad
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 280,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Ícono central de Pausa / Reproducción al tocar
          if (_showPlayPauseOverlay && _controller != null)
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _controller!.value.isPlaying
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    size: 54,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Barra inferior con información del autor y descripción
          Positioned(
            left: 16,
            right: 80,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      widget.video.userHandle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Seguir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.video.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    height: 1.3,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.music_note_rounded,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.video.songTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Columna derecha con botones de interacción: Like, Comentarios, Compartir
          Positioned(
            right: 12,
            bottom: 28,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar del creador
                _buildAvatarButton(),
                const SizedBox(height: 20),

                // Botón de Me Gusta
                _buildActionButton(
                  icon: widget.video.isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: widget.video.isLiked ? Colors.redAccent : Colors.white,
                  count: '${widget.video.likes}',
                  onTap: () {
                    setState(() {
                      widget.video.isLiked = !widget.video.isLiked;
                      if (widget.video.isLiked) {
                        widget.video.likes++;
                      } else {
                        widget.video.likes--;
                      }
                    });
                  },
                ),
                const SizedBox(height: 18),

                // Botón de Comentarios
                _buildActionButton(
                  icon: Icons.chat_bubble_rounded,
                  color: Colors.white,
                  count: '${widget.video.comments}',
                  onTap: () {
                    _showCommentsSheet(context);
                  },
                ),
                const SizedBox(height: 18),

                // Botón de Compartir
                _buildActionButton(
                  icon: Icons.share_rounded,
                  color: Colors.white,
                  count: '${widget.video.shares}',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Enlace compartido: ${widget.video.userHandle}'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Disco de música giratorio
                _buildMusicDisc(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_hasError) {
      return Container(
        color: const Color(0xFF121212),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white54,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'No se pudo reproducir el video',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                  });
                  _initializeVideo();
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text(
                  'Reintentar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      );
    }

    final isPortrait = MediaQuery.of(context).size.aspectRatio < 1;
    return Container(
      color: Colors.black,
      child: Center(
        child: isPortrait
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: _controller!.value.size.width > 0
                        ? _controller!.value.size.width
                        : 1080,
                    height: _controller!.value.size.height > 0
                        ? _controller!.value.size.height
                        : 1920,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              )
            : AspectRatio(
                aspectRatio: _controller!.value.aspectRatio > 0
                    ? _controller!.value.aspectRatio
                    : 9 / 16,
                child: VideoPlayer(_controller!),
              ),
      ),
    );
  }

  Widget _buildAvatarButton() {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.deepOrange],
            ),
          ),
          child: Center(
            child: Text(
              widget.video.userName.isNotEmpty
                  ? widget.video.userName[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -7,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.black87,
                  blurRadius: 3,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicDisc() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black87,
        border: Border.all(color: Colors.white38, width: 2),
      ),
      child: const Center(
        child: Icon(
          Icons.album_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  '${widget.video.comments} comentarios',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Divider(color: Colors.white12),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.white10),
                    itemBuilder: (context, i) {
                      final nombres = [
                        'Carlos Daniel',
                        'María Fernanda',
                        'Andrés Felipe',
                        'Laura Sofía',
                      ];
                      final comentarios = [
                        '¡Excelente video! Muy bien logrado el efecto vertical 👏',
                        'Totalmente de acuerdo con el mensaje del video 🚀',
                        '¿Con qué cámara o herramienta fue grabado? Impresionante calidad.',
                        'Favorito guardado ❤️',
                      ];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.primaries[i % Colors.primaries.length],
                          child: Text(nombres[i][0]),
                        ),
                        title: Text(
                          nombres[i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          comentarios[i],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
