import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/record.dart';

/// A tiny SharedPreferences-backed implementation for web builds.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  String _keyFor(String table) => 'matooke_db::$table';

  Future<List<Map<String, dynamic>>> _readList(String table) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(table));
    if (raw == null) return [];
    try {
      final lst = json.decode(raw) as List<dynamic>;
      return lst.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _writeList(String table, List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = json.encode(list);
    await prefs.setString(_keyFor(table), raw);
  }

  Future<int> createRecord(String table, Record rec) async {
    final list = await _readList(table);
    final id = DateTime.now().millisecondsSinceEpoch;
    final map = rec.toMap();
    map['id'] = id;
    list.add(map);
    await _writeList(table, list);
    return id;
  }

  Future<List<Record>> readAllRecords(String table) async {
    final list = await _readList(table);
    // sort by date desc (date stored as ISO)
    list.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
    return list.map((m) => Record.fromMap(m)).toList();
  }

  Future<int> updateRecord(String table, Record rec) async {
    if (rec.id == null) return 0;
    final list = await _readList(table);
    final idx = list.indexWhere((e) => e['id'] == rec.id);
    if (idx == -1) return 0;
    list[idx] = rec.toMap();
    list[idx]['id'] = rec.id;
    await _writeList(table, list);
    return 1;
  }

  Future<int> deleteRecord(String table, int id) async {
    final list = await _readList(table);
    list.removeWhere((e) => e['id'] == id);
    await _writeList(table, list);
    return 1; // return 1 for compatibility
  }

  Future<double> totalQuantity(String table) async {
    final list = await _readList(table);
    double s = 0.0;
    for (final e in list) {
      final q = e['quantity'];
      if (q is int) {
        s += q.toDouble();
      } else if (q is double) {
        s += q;
      } else if (q is String) {
        s += double.tryParse(q) ?? 0.0;
      }
    }
    return s;
  }

  Future<Map<String, double>> totalsByCrop(String table) async {
    final list = await _readList(table);
    final Map<String, double> result = {};
    for (final e in list) {
      final cropName = e['crop_name'] as String? ?? 'Unknown';
      final q = e['quantity'];
      double qty = 0.0;
      if (q is int) {
        qty = q.toDouble();
      } else if (q is double) {
        qty = q;
      } else if (q is String) {
        qty = double.tryParse(q) ?? 0.0;
      }
      result[cropName] = (result[cropName] ?? 0.0) + qty;
    }
    return result;
  }

  Future close() async {}
}
