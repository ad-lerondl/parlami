/// Italian radio stations shared by the CO module and the noisy-listening
/// scenario. Keeping the list in one place lets every module offer the same
/// live Italian speech sources.
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
}

const List<RadioStation> italianRadioStations = [
  RadioStation(
    name: 'Radio RAI 1',
    streamUrl: 'https://icestreaming.rai.it/1.mp3',
    descriptionKey: 'coRadioGeneral',
    region: 'National',
  ),
  RadioStation(
    name: 'Radio RAI 2',
    streamUrl: 'https://icestreaming.rai.it/2.mp3',
    descriptionKey: 'coMusicEntertainment',
    region: 'National',
  ),
  RadioStation(
    name: 'Radio RAI 3',
    streamUrl: 'https://icestreaming.rai.it/3.mp3',
    descriptionKey: 'coCultureNews',
    region: 'National',
  ),
  RadioStation(
    name: 'RDS',
    streamUrl: 'https://icstream.rds.radio/rds',
    descriptionKey: 'coPopNews',
    region: 'National',
  ),
  RadioStation(
    name: 'Radio 105',
    streamUrl: 'https://icy.unitedradio.it/Radio105.mp3',
    descriptionKey: 'coMusicEntertainment',
    region: 'National',
  ),
  RadioStation(
    name: 'RTL 102.5',
    streamUrl: 'https://streamingv2.shoutcast.com/rtl-1025',
    descriptionKey: 'coRadioNewsMusic',
    region: 'National',
  ),
];
