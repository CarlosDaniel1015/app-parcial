class VideoItemModel {
  final String id;
  final String videoUrl;
  final String userName;
  final String userHandle;
  final String description;
  final String songTitle;
  int likes;
  int comments;
  int shares;
  bool isLiked;

  VideoItemModel({
    required this.id,
    required this.videoUrl,
    required this.userName,
    required this.userHandle,
    required this.description,
    required this.songTitle,
    required this.likes,
    required this.comments,
    required this.shares,
    this.isLiked = false,
  });

  /// Lista de videos verticales obtenidos de Pexels (https://www.pexels.com/es-es/buscar/videos/vertical/)
  /// Se utilizan enlaces directos a la CDN de Pexels para evitar almacenar archivos de video pesados en el repositorio de GitHub.
  static List<VideoItemModel> getSampleVideos() {
    return [
      VideoItemModel(
        id: '1',
        videoUrl:
            'https://videos.pexels.com/video-files/7297870/7297870-hd_1080_1920_30fps.mp4',
        userName: 'Andrea Piacquadio',
        userHandle: '@andrea_travels',
        description:
            'Caminando por las calles de la ciudad al atardecer 🌆✨ Momentos únicos que inspiran. #pexels #vertical #urban',
        songTitle: 'Urban Sunset - Lo-Fi Beats',
        likes: 3820,
        comments: 245,
        shares: 180,
      ),
      VideoItemModel(
        id: '2',
        videoUrl:
            'https://videos.pexels.com/video-files/4678261/4678261-hd_1080_1920_25fps.mp4',
        userName: 'Cottonbro Studio',
        userHandle: '@cottonbro_films',
        description:
            'Creatividad sin límites en movimiento 🎨 Expresión artística y estilo cinematográfico vertical. #arte #vertical #estilo',
        songTitle: 'Vibes & Rhythm - Indie Chill',
        likes: 5410,
        comments: 412,
        shares: 360,
      ),
      VideoItemModel(
        id: '3',
        videoUrl:
            'https://videos.pexels.com/video-files/4434150/4434150-hd_1080_1920_30fps.mp4',
        userName: 'Kelly Lacy',
        userHandle: '@kelly_nature',
        description:
            'Paisajes y naturaleza viva 🌿 Respira aire puro y desconéctate de la rutina diaria. #naturaleza #relax #vertical',
        songTitle: 'Calm Waves - Acústico Relajante',
        likes: 2190,
        comments: 138,
        shares: 92,
      ),
      VideoItemModel(
        id: '4',
        videoUrl:
            'https://videos.pexels.com/video-files/11280923/11280923-hd_1080_1920_60fps.mp4',
        userName: 'Taryn Elliott',
        userHandle: '@taryn_creative',
        description:
            'Explorando nuevos horizontes 🌅 Cada día trae una nueva aventura para descubrir. #aventura #lifestyle #viajes',
        songTitle: 'Golden Hour - Synthwave Melodic',
        likes: 8930,
        comments: 720,
        shares: 654,
      ),
      VideoItemModel(
        id: '5',
        videoUrl:
            'https://videos.pexels.com/video-files/6275050/6275050-hd_1080_1920_30fps.mp4',
        userName: 'Rostislav Uzunov',
        userHandle: '@rostislav_video',
        description:
            'Luces nocturnas y vida urbana 🌃 La magia de la noche en alta definición vertical 1080x1920. #nightlife #city #vibes',
        songTitle: 'Midnight Drive - Lo-Fi Dreams',
        likes: 4620,
        comments: 310,
        shares: 215,
      ),
    ];
  }
}
