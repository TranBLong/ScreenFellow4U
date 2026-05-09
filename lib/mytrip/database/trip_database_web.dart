import 'dart:convert';
import 'dart:html' as html;

import '../models/trip.dart';

class TripDatabase {
  static final TripDatabase instance = TripDatabase._init();
  static const String _storageKey = 'my_trips';

  final List<Trip> _cache = [];
  bool _loaded = false;

  TripDatabase._init();

  Future<void> _ensureLoaded() async {
    if (_loaded) return;

    try {
      final raw = html.window.localStorage[_storageKey];
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          _cache
            ..clear()
            ..addAll(
              decoded
                  .whereType<Map>()
                  .map((item) => Trip.fromMap(Map<String, dynamic>.from(item))),
            );
        }
      }
    } catch (_) {
      // Some browsers block storage in restricted modes; fall back to memory.
    }

    _loaded = true;
  }

  Future<void> _persist() async {
    try {
      html.window.localStorage[_storageKey] = jsonEncode(
        _cache.map((trip) => trip.toMap()).toList(),
      );
    } catch (_) {
      // Keep data in memory if persistent storage is unavailable.
    }
  }

  int _nextId() {
    if (_cache.isEmpty) return 1;
    return _cache.map((trip) => trip.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<Trip> create(Trip trip) async {
    await _ensureLoaded();
    final saved = trip.copyWith(id: _nextId());
    _cache.add(saved);
    await _persist();
    return saved;
  }

  Future<Trip?> readTrip(int id) async {
    await _ensureLoaded();
    for (final trip in _cache) {
      if (trip.id == id) {
        return trip;
      }
    }
    return null;
  }

  Future<List<Trip>> readAllTrips() async {
    await _ensureLoaded();
    final trips = List<Trip>.from(_cache)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return trips;
  }

  Future<int> update(Trip trip) async {
    await _ensureLoaded();
    final index = _cache.indexWhere((item) => item.id == trip.id);
    if (index == -1) {
      return 0;
    }
    _cache[index] = trip;
    await _persist();
    return 1;
  }

  Future<int> delete(int id) async {
    await _ensureLoaded();
    final index = _cache.indexWhere((item) => item.id == id);
    if (index == -1) {
      return 0;
    }
    _cache.removeAt(index);
    await _persist();
    return 1;
  }

  Future<void> close() async {}
}
