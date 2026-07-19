import 'package:flutter_tts/flutter_tts.dart';

/// App-wide text-to-speech coordinator. A single engine prevents overlapping
/// native TTS instances as users move between screens.
class VoiceService {
  VoiceService._();

  static final VoiceService instance = VoiceService._();

  final FlutterTts _tts = FlutterTts();
  Future<void>? _initialization;
  String? _lastMessage;
  DateTime? _lastSpokenAt;

  Future<void> _initialize() {
    return _initialization ??= _configure();
  }

  Future<void> _configure() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(false);
  }

  Future<void> speak(String message) async {
    final normalizedMessage = message.trim();
    if (normalizedMessage.isEmpty) return;

    final now = DateTime.now();
    if (_lastMessage == normalizedMessage &&
        _lastSpokenAt != null &&
        now.difference(_lastSpokenAt!) < const Duration(seconds: 2)) {
      return;
    }

    try {
      await _initialize();
      await _tts.stop();
      _lastMessage = normalizedMessage;
      _lastSpokenAt = now;
      await _tts.speak(normalizedMessage);
    } catch (_) {
      // Voice feedback must never interrupt the existing user workflow.
    }
  }

  Future<void> speakError(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('permission-denied')) return speak('Permission denied.');
    if (text.contains('network') || text.contains('unavailable')) {
      return speak('Network connection failed. Please try again.');
    }
    if (text.contains('not found') || text.contains('not-found')) {
      return speak('Record not found.');
    }
    if (text.contains('firebase')) {
      return speak('Unable to connect to Firebase. Please try again.');
    }
    return speak('Something went wrong. Please try again.');
  }

  Future<void> stop() => _tts.stop();
}
