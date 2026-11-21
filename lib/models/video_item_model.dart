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

  static List<VideoItemModel> getSampleVideos() {
    return [
      VideoItemModel(
        id: '1',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        userName: 'Abejas del Saber',
        userHandle: '@abejas_tech',
        description:
            'Polinización en cámara lenta 🐝 Increíble trabajo en equipo en la naturaleza. #macro #naturaleza #colombia',
        songTitle: 'Abejas Trabajadoras - Lo-Fi Naturaleza',
        likes: 3820,
        comments: 245,
        shares: 180,
      ),
      VideoItemModel(
        id: '2',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        userName: 'Mariposas del Valle',
        userHandle: '@mariposas_valle',
        description:
            'Colores fascinantes en plena transformación 🦋 El ciclo de la vida en acción. #flutter #vida #biodiversidad',
        songTitle: 'Vuelo Libre - Acústico Instrumental',
        likes: 5410,
        comments: 412,
        shares: 360,
      ),
      VideoItemModel(
        id: '3',
        videoUrl:
            'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
        userName: 'Jardines Botánicos',
        userHandle: '@jardines_pro',
        description:
            'Floración mágica en timelapse 🌸 Respira hondo y disfruta este momento de paz. #relax #flores #belleza',
        songTitle: 'Jardín Zen - Meditación & Calma',
        likes: 2190,
        comments: 138,
        shares: 92,
      ),
      VideoItemModel(
        id: '4',
        videoUrl:
            'https://raw.githubusercontent.com/mediaelement/mediaelement-files/master/big_buck_bunny.mp4',
        userName: 'Animación Digital Unitecnar',
        userHandle: '@blender_creators',
        description:
            'El clásico Big Buck Bunny renderizado en código abierto 🐰 ¿Quién recuerda este proyecto? #3d #blender #cine',
        songTitle: 'Banda Sonora Original - Orquesta 3D',
        likes: 8930,
        comments: 720,
        shares: 654,
      ),
      VideoItemModel(
        id: '5',
        videoUrl:
            'https://raw.githubusercontent.com/intel-iot-devkit/sample-videos/master/person-bicycle-car-detection.mp4',
        userName: 'Ingeniería de Sistemas',
        userHandle: '@ia_unitecnar',
        description:
            'Visión artificial en ciudades inteligentes: detección de personas y vehículos en tiempo real 🚴🏙️ #ia #smartcity #unitecnar',
        songTitle: 'Cyber City 2026 - Synthwave Electrónico',
        likes: 4620,
        comments: 310,
        shares: 215,
      ),
    ];
  }
}
