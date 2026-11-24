import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/app_localizations.dart';
import '../../services/asset_loader.dart';
import '../../services/study_session_tracker.dart';

class SongModel {
  const SongModel(this.id, this.title, this.artist, this.year, this.difficulty, this.why, this.vocab);

  final String id;
  final String title;
  final String artist;
  final String year;
  final int difficulty;
  final String why;
  final List<MapEntry<String, String>> vocab;

  static SongModel fromJson(Map<String, dynamic> raw) {
    return SongModel(
      raw['id'] as String,
      raw['title'] as String,
      raw['artist'] as String,
      raw['year'] as String,
      (raw['difficulty'] as num? ?? 1).toInt(),
      raw['why'] as String? ?? '',
      ((raw['vocab'] as List? ?? const []).cast<Map<String, dynamic>>())
          .map((entry) => MapEntry(entry['it'] as String, entry['fr'] as String))
          .toList(growable: false),
    );
  }
}

class SongsView extends StatefulWidget {
  const SongsView({super.key});

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  static const _prefsKey = 'canzoni_memorizzate';

  List<SongModel> _songs = [];
  Set<String> _memorized = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    StudySessionTracker.instance.start('songs');
    _load();
  }

  @override
  void dispose() {
    StudySessionTracker.instance.stop();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await AssetLoader.loadJson('assets/culture/canzoni.json')
        as Map<String, dynamic>;
    final preferences = await SharedPreferences.getInstance();
    final stored = preferences.getString(_prefsKey);
    final memorized = stored == null
        ? <String>{}
        : (json.decode(stored) as List).cast<String>().toSet();
    if (!mounted) return;
    setState(() {
      _songs = (data['songs'] as List)
          .cast<Map<String, dynamic>>()
          .map(SongModel.fromJson)
          .toList(growable: false);
      _memorized = memorized;
      _loaded = true;
    });
  }

  Future<void> _toggleMemorized(String songId, bool value) async {
    setState(() {
      if (value) {
        _memorized.add(songId);
      } else {
        _memorized.remove(songId);
      }
    });
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_prefsKey, json.encode(_memorized.toList()));
  }

  Future<void> _openSearch(SongModel song) async {
    final query = Uri.encodeComponent('${song.title} ${song.artist} italien');
    final uri = Uri.parse('https://www.youtube.com/results?search_query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final done = _songs.where((song) => _memorized.contains(song.id)).length;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.learnSongs)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.songsProgress(done, _songs.length),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ..._songs.map(_buildSongCard),
        ],
      ),
    );
  }

  Widget _buildSongCard(SongModel song) {
    final l10n = AppLocalizations.of(context)!;
    final isMemorized = _memorized.contains(song.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(song.title, style: Theme.of(context).textTheme.titleMedium),
                      Text('${song.artist} · ${song.year}'),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Icon(
                      index < song.difficulty ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(song.why),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: song.vocab.map((entry) {
                return Chip(
                  label: Text('${entry.key} = ${entry.value}'),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(l10n.songsMemorized),
                    value: isMemorized,
                    onChanged: (value) => _toggleMemorized(song.id, value ?? false),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openSearch(song),
                  icon: const Icon(Icons.play_circle_outline),
                  label: Text(l10n.songsListen),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
