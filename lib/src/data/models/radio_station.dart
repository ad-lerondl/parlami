class RadioStation {
  final String name;
  final String streamUrl;
  final String descriptionKey;
  final String region;

  const RadioStation({
    required this.name,
    required this.streamUrl,
    required this.descriptionKey,
    required this.region,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      name: json['name']?.toString() ?? '',
      streamUrl: json['streamUrl']?.toString() ?? '',
      descriptionKey: json['descriptionKey']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
    );
  }
}
