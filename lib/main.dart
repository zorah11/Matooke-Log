import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import 'db/database_helper.dart';
import 'models/record.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MatookeApp());
}

class MatookeApp extends StatelessWidget {
  const MatookeApp({super.key});

  static const primary = Color(0xFF4CAF50);
  static const accent = Color(0xFFFFEB3B);
  static const background = Color(0xFFFFF8E1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matooke Log',
      theme: ThemeData(
        primaryColor: primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: accent,
        ),
        scaffoldBackgroundColor: background,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.eco,
              size: 96,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Matooke Log',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Your harvest, your records, your pride.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RecordListScreen(table: 'planting_records', title: 'Planting'),
    const RecordListScreen(table: 'harvest_records', title: 'Harvest'),
    const RecordListScreen(table: 'sales_records', title: 'Sales'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.agriculture),
              label: 'Planting',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_nature),
              label: 'Harvest',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Sales',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Matooke Log',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.eco, size: 80, color: Colors.white70),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Quick Stats',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const StatsCardsRow(),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.show_chart,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Summary',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const SummaryContent(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Made in Uganda 🇺🇬',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCardsRow extends StatefulWidget {
  const StatsCardsRow({super.key});

  @override
  State<StatsCardsRow> createState() => _StatsCardsRowState();
}

class _StatsCardsRowState extends State<StatsCardsRow> {
  final db = DatabaseHelper.instance;
  double planted = 0, harvested = 0, sold = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final p = await db.totalQuantity('planting_records');
    final h = await db.totalQuantity('harvest_records');
    final s = await db.totalQuantity('sales_records');
    setState(() {
      planted = p;
      harvested = h;
      sold = s;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Planted',
            planted.toStringAsFixed(0),
            Icons.agriculture,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Harvested',
            harvested.toStringAsFixed(0),
            Icons.emoji_nature,
            Colors.brown,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Sold',
            sold.toStringAsFixed(0),
            Icons.shopping_bag,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryContent extends StatefulWidget {
  const SummaryContent({super.key});

  @override
  State<SummaryContent> createState() => _SummaryContentState();
}

class _SummaryContentState extends State<SummaryContent> {
  final db = DatabaseHelper.instance;
  String _selectedTable = 'planting_records';
  Map<String, double> _breakdown = {};

  @override
  void initState() {
    super.initState();
    _loadBreakdown();
  }

  Future<void> _loadBreakdown() async {
    final data = await db.totalsByCrop(_selectedTable);
    setState(() => _breakdown = data);
  }

  @override
  Widget build(BuildContext context) {
    final entries = _breakdown.entries.toList();
    final colors = List.generate(
      entries.length,
      (i) =>
          Colors.primaries[i % Colors.primaries.length].withValues(alpha: 0.85),
    );

    return Column(
      children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'planting_records',
              label: Text('Planting'),
              icon: Icon(Icons.agriculture),
            ),
            ButtonSegment(
              value: 'harvest_records',
              label: Text('Harvest'),
              icon: Icon(Icons.emoji_nature),
            ),
            ButtonSegment(
              value: 'sales_records',
              label: Text('Sales'),
              icon: Icon(Icons.shopping_bag),
            ),
          ],
          selected: {_selectedTable},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              _selectedTable = newSelection.first;
              _loadBreakdown();
            });
          },
        ),
        const SizedBox(height: 16),
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text('No data yet', style: TextStyle(color: Colors.grey)),
          )
        else
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: entries.asMap().entries.map((e) {
                  final idx = e.key;
                  final kv = e.value;
                  return PieChartSectionData(
                    value: kv.value,
                    color: colors[idx],
                    title: '${kv.key}\n${kv.value.toStringAsFixed(0)}',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
      ],
    );
  }
}

class RecordListScreen extends StatefulWidget {
  final String table;
  final String title;
  const RecordListScreen({required this.table, required this.title, super.key});
  @override
  State<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  final db = DatabaseHelper.instance;
  late Future<List<Record>> _future;
  final _searchCtrl = TextEditingController();
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _reload();
    _searchCtrl.addListener(
      () => setState(() => _filter = _searchCtrl.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _reload() {
    _future = db.readAllRecords(widget.table);
    setState(() {});
  }

  Future<void> _delete(int id) async {
    await db.deleteRecord(widget.table, id);
    _reload();
  }

  String _escapeCsv(String s) {
    if (s.contains(',') || s.contains('"') || s.contains('\n')) {
      final escaped = s.replaceAll('"', '""');
      return '"$escaped"';
    }
    return s;
  }

  String _toCsv(List<Record> items) {
    final sb = StringBuffer();
    sb.writeln('id,crop_name,date,quantity,notes');
    for (final r in items) {
      final id = r.id?.toString() ?? '';
      final crop = _escapeCsv(r.cropName);
      final date = r.date;
      final qty = r.quantity.toString();
      final notes = _escapeCsv(r.notes ?? '');
      sb.writeln([id, crop, date, qty, notes].join(','));
    }
    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    final IconData icon = widget.table == 'planting_records'
        ? Icons.agriculture
        : widget.table == 'harvest_records'
        ? Icons.emoji_nature
        : Icons.shopping_bag;

    final Color color = widget.table == 'planting_records'
        ? Colors.green
        : widget.table == 'harvest_records'
        ? Colors.brown
        : Colors.orange;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: color,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text('${widget.title} Records'),
                ],
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                tooltip: 'Export CSV',
                icon: const Icon(Icons.download_rounded),
                onPressed: () async {
                  final items = await db.readAllRecords(widget.table);
                  final csv = _toCsv(items);
                  await Clipboard.setData(ClipboardData(text: csv));
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('CSV copied to clipboard'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: color),
                  hintText: 'Search by crop name...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
          FutureBuilder<List<Record>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final items = snap.data ?? [];
              final filtered = items
                  .where((r) => r.cropName.toLowerCase().contains(_filter))
                  .toList();

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No records yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your first record',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    final r = filtered[i];
                    return Dismissible(
                      key: ValueKey(r.id ?? i),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white, size: 28),
                            SizedBox(height: 4),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (_) {
                        if (r.id != null) _delete(r.id!);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            final changed = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddEditRecordScreen(
                                  table: widget.table,
                                  record: r,
                                ),
                              ),
                            );
                            if (changed == true) _reload();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(icon, color: color, size: 28),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.cropName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat.yMMMd().format(
                                          DateTime.parse(r.date),
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (r.notes != null &&
                                          r.notes!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          r.notes!,
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    r.quantity.toStringAsFixed(0),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }, childCount: filtered.length),
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddEditRecordScreen(table: widget.table),
            ),
          );
          if (created == true) _reload();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
        backgroundColor: color,
      ),
    );
  }
}

class AddEditRecordScreen extends StatefulWidget {
  final String table;
  final Record? record;
  const AddEditRecordScreen({required this.table, this.record, super.key});
  @override
  State<AddEditRecordScreen> createState() => _AddEditRecordScreenState();
}

class _AddEditRecordScreenState extends State<AddEditRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  final db = DatabaseHelper.instance;
  final defaults = [
    'Matooke',
    'Beans',
    'Maize',
    'Coffee',
    'Cassava',
    'Sweet Potatoes',
    'Bananas',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      final r = widget.record!;
      _cropCtrl.text = r.cropName;
      _qtyCtrl.text = r.quantity.toString();
      _notesCtrl.text = r.notes ?? '';
      _date = DateTime.parse(r.date);
    }
  }

  @override
  void dispose() {
    _cropCtrl.dispose();
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final rec = Record(
      id: widget.record?.id,
      cropName: _cropCtrl.text.trim(),
      date: _date.toIso8601String(),
      quantity: double.tryParse(_qtyCtrl.text.trim()) ?? 0.0,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
    if (widget.record == null) {
      await db.createRecord(widget.table, rec);
    } else {
      await db.updateRecord(widget.table, rec);
    }
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (d != null) setState(() => _date = d);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.record != null;

    // Icon and color based on table
    IconData icon;
    Color color;
    String title;
    switch (widget.table) {
      case 'planting_records':
        icon = Icons.eco;
        color = const Color(0xFF4CAF50);
        title = isEditing ? 'Edit Planting' : 'Add Planting';
        break;
      case 'harvest_records':
        icon = Icons.agriculture;
        color = const Color(0xFFFF9800);
        title = isEditing ? 'Edit Harvest' : 'Add Harvest';
        break;
      case 'sales_records':
        icon = Icons.shopping_bag;
        color = const Color(0xFF2196F3);
        title = isEditing ? 'Edit Sale' : 'Add Sale';
        break;
      default:
        icon = Icons.note;
        color = Colors.grey;
        title = isEditing ? 'Edit Record' : 'Add Record';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(title),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card with icon
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 40, color: color),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Crop selection
              Text(
                'Crop Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _cropCtrl.text.isEmpty ? null : _cropCtrl.text,
                items: defaults
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) _cropCtrl.text = v;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.grass, color: color),
                  hintText: 'Select crop',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (v) {
                  final typed = _cropCtrl.text.trim();
                  if ((v != null && v.trim().isNotEmpty) || typed.isNotEmpty) {
                    return null;
                  }
                  return 'Please select or enter crop name';
                },
              ),

              const SizedBox(height: 16),

              // Custom crop name
              TextFormField(
                controller: _cropCtrl,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.edit, color: color),
                  hintText: 'Or type custom crop name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Date picker
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          DateFormat.yMMMMd().format(_date),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quantity
              Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _qtyCtrl,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.numbers, color: color),
                  hintText: 'Enter quantity (e.g., 100)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) => (v == null || double.tryParse(v) == null)
                    ? 'Please enter a valid number'
                    : null,
              ),

              const SizedBox(height: 24),

              // Notes
              Text(
                'Notes (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.notes, color: color),
                  ),
                  hintText: 'Add any additional notes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        isEditing ? 'Update Record' : 'Save Record',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});
  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final db = DatabaseHelper.instance;
  String _selectedTable = 'planting_records';
  Map<String, double> _breakdown = {};

  @override
  void initState() {
    super.initState();
    _loadBreakdown();
  }

  Future<void> _loadBreakdown() async {
    final data = await db.totalsByCrop(_selectedTable);
    setState(() => _breakdown = data);
  }

  @override
  Widget build(BuildContext context) {
    final total = _breakdown.values.fold<double>(0.0, (a, b) => a + b);
    final entries = _breakdown.entries.toList();
    final colors = List.generate(
      entries.length,
      (i) =>
          Colors.primaries[i % Colors.primaries.length].withValues(alpha: 0.85),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedTable,
                    items: const [
                      DropdownMenuItem(
                        value: 'planting_records',
                        child: Text('Planting'),
                      ),
                      DropdownMenuItem(
                        value: 'harvest_records',
                        child: Text('Harvest'),
                      ),
                      DropdownMenuItem(
                        value: 'sales_records',
                        child: Text('Sales'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _selectedTable = v;
                          _loadBreakdown();
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadBreakdown,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statTile(
                      'Total',
                      total,
                      Theme.of(context).colorScheme.primary,
                    ),
                    _statTile(
                      'Types',
                      _breakdown.length.toDouble(),
                      Colors.brown,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: entries.isEmpty
                            ? const Center(child: Text('No data'))
                            : PieChart(
                                PieChartData(
                                  sections: entries.asMap().entries.map((e) {
                                    final idx = e.key;
                                    final kv = e.value;
                                    return PieChartSectionData(
                                      value: kv.value,
                                      color: colors[idx],
                                      title:
                                          '${kv.key} (${kv.value.toStringAsFixed(0)})',
                                      radius: 48,
                                    );
                                  }).toList(),
                                  sectionsSpace: 4,
                                  centerSpaceRadius: 24,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: entries.isEmpty
                            ? const SizedBox.shrink()
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 220,
                                      child: BarChart(
                                        BarChartData(
                                          alignment:
                                              BarChartAlignment.spaceAround,
                                          maxY:
                                              (entries
                                                          .map((e) => e.value)
                                                          .fold(
                                                            0.0,
                                                            (a, b) =>
                                                                a > b ? a : b,
                                                          ) *
                                                      1.4)
                                                  .clamp(5.0, double.infinity),
                                          barTouchData: BarTouchData(
                                            enabled: true,
                                          ),
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (v, meta) {
                                                  final idx = v.toInt();
                                                  if (idx < 0 ||
                                                      idx >= entries.length) {
                                                    return const SizedBox.shrink();
                                                  }
                                                  return SideTitleWidget(
                                                    meta: meta,
                                                    child: Text(
                                                      entries[idx].key,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          borderData: FlBorderData(show: false),
                                          gridData: const FlGridData(
                                            show: false,
                                          ),
                                          barGroups: entries
                                              .asMap()
                                              .entries
                                              .map(
                                                (e) => BarChartGroupData(
                                                  x: e.key,
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: e.value.value,
                                                      color: colors[e.key],
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: entries
                                          .asMap()
                                          .entries
                                          .map(
                                            (e) => Chip(
                                              backgroundColor: colors[e.key],
                                              label: Text(
                                                '${e.value.key} — ${e.value.value.toStringAsFixed(0)}',
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statTile(String label, double value, Color color) => Column(
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      CircleAvatar(
        radius: 28,
        backgroundColor: color,
        child: Text(
          value.toStringAsFixed(0),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}
