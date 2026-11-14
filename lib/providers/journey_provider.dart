import 'package:flutter/foundation.dart';

import '../models/career_journey.dart';
import '../services/local_store.dart';

class JourneyUndo {
  final String assessmentId;
  final String actionId;
  final bool wasCompleted;

  const JourneyUndo({
    required this.assessmentId,
    required this.actionId,
    required this.wasCompleted,
  });
}

class JourneyProvider extends ChangeNotifier {
  LocalStore _store;
  final DateTime Function() _now;

  CareerJourney? _activeJourney;
  bool _isLoading = false;
  Object? _lastError;

  JourneyProvider({
    required LocalStore store,
    DateTime Function()? now,
  })  : _store = store,
        _now = now ?? DateTime.now;

  CareerJourney? get activeJourney => _activeJourney;
  bool get isLoading => _isLoading;
  Object? get lastError => _lastError;

  Future<void> load() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();
    try {
      _activeJourney = await _store.getJourney();
    } catch (error) {
      _lastError = error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> switchStore(LocalStore store) async {
    _store = store;
    await load();
  }

  Future<void> startJourney(CareerJourney journey) async {
    final previous = _activeJourney;
    _activeJourney = journey;
    _lastError = null;
    notifyListeners();
    try {
      await _persist(journey);
    } catch (_) {
      _activeJourney = previous;
      notifyListeners();
      rethrow;
    }
  }

  Future<JourneyUndo?> toggleAction(String actionId) async {
    final current = _activeJourney;
    if (current == null) return null;
    final wasCompleted = current.completedActionIds.contains(actionId);
    final updated = current.toggleAction(actionId, now: _now());
    if (identical(updated, current)) return null;
    _activeJourney = updated;
    notifyListeners();
    try {
      await _persist(updated);
    } catch (_) {
      _activeJourney = current;
      notifyListeners();
      rethrow;
    }
    return JourneyUndo(
      assessmentId: current.assessmentId,
      actionId: actionId,
      wasCompleted: wasCompleted,
    );
  }

  Future<void> undoToggle(JourneyUndo undo) async {
    final current = _activeJourney;
    if (current == null || current.assessmentId != undo.assessmentId) return;
    final isCompleted = current.completedActionIds.contains(undo.actionId);
    if (isCompleted == undo.wasCompleted) return;
    final updated = current.toggleAction(undo.actionId, now: _now());
    _activeJourney = updated;
    notifyListeners();
    try {
      await _persist(updated);
    } catch (_) {
      _activeJourney = current;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _persist(CareerJourney journey) async {
    try {
      await _store.saveJourney(journey);
      _lastError = null;
    } catch (error) {
      _lastError = error;
      notifyListeners();
      rethrow;
    }
  }
}
