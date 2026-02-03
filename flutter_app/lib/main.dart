import 'package:flutter/material.dart';

void main() {
  runApp(const BoltFlutterBuilderApp());
}

class BoltFlutterBuilderApp extends StatelessWidget {
  const BoltFlutterBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bolt Flutter Builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const BuilderHomeScreen(),
    );
  }
}

enum FrameworkChoice { expo, react }

enum BuildStage { idle, planning, generating, previewing, complete }

class BuilderHomeScreen extends StatefulWidget {
  const BuilderHomeScreen({super.key});

  @override
  State<BuilderHomeScreen> createState() => _BuilderHomeScreenState();
}

class _BuilderHomeScreenState extends State<BuilderHomeScreen> {
  final TextEditingController _projectController =
      TextEditingController(text: 'expo-realtime-dashboard');
  final TextEditingController _apiBaseController =
      TextEditingController(text: 'https://api.example.com');
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _commandController = TextEditingController();

  FrameworkChoice _frameworkChoice = FrameworkChoice.expo;
  BuildStage _buildStage = BuildStage.idle;
  bool _useE2B = true;

  final List<String> _activityLog = [
    'AI ready to plan your build.',
    'Waiting for command input.',
  ];

  @override
  void dispose() {
    _projectController.dispose();
    _apiBaseController.dispose();
    _apiKeyController.dispose();
    _commandController.dispose();
    super.dispose();
  }

  void _logActivity(String message) {
    setState(() {
      _activityLog.insert(0, message);
    });
  }

  void _startBuild() {
    setState(() {
      _buildStage = BuildStage.planning;
    });
    _logActivity('AI planning build for ${_projectController.text}.');

    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _buildStage = BuildStage.generating;
      });
      _logActivity('Generating files and wiring API endpoints.');
    });

    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _buildStage = BuildStage.previewing;
      });
      _logActivity('Launching preview and streaming updates.');
    });

    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _buildStage = BuildStage.complete;
      });
      _logActivity('Preview ready. Terminal connected.');
    });
  }

  void _runCommand() {
    final command = _commandController.text.trim();
    if (command.isEmpty) {
      return;
    }
    _logActivity('Terminal: $command');
    _commandController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBackground = isDark ? Colors.black : Colors.grey[50];

    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        title: const Text('Bolt Flutter Builder'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.icon(
              onPressed: _startBuild,
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('Start AI Build'),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderRow(
                  buildStage: _buildStage,
                  frameworkChoice: _frameworkChoice,
                  onFrameworkChanged: (choice) {
                    setState(() {
                      _frameworkChoice = choice;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth > 1100
                          ? (constraints.maxWidth - 48) / 2
                          : constraints.maxWidth,
                      child: _ConfigCard(
                        projectController: _projectController,
                        apiBaseController: _apiBaseController,
                        apiKeyController: _apiKeyController,
                        useE2B: _useE2B,
                        onToggleE2B: (value) {
                          setState(() {
                            _useE2B = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth > 1100
                          ? (constraints.maxWidth - 48) / 2
                          : constraints.maxWidth,
                      child: _PreviewCard(buildStage: _buildStage),
                    ),
                    SizedBox(
                      width: constraints.maxWidth > 1100
                          ? (constraints.maxWidth - 48) / 2
                          : constraints.maxWidth,
                      child: _TerminalCard(
                        commandController: _commandController,
                        onRunCommand: _runCommand,
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth > 1100
                          ? (constraints.maxWidth - 48) / 2
                          : constraints.maxWidth,
                      child: _ActivityCard(activityLog: _activityLog),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.buildStage,
    required this.frameworkChoice,
    required this.onFrameworkChanged,
  });

  final BuildStage buildStage;
  final FrameworkChoice frameworkChoice;
  final ValueChanged<FrameworkChoice> onFrameworkChanged;

  String get _stageLabel {
    switch (buildStage) {
      case BuildStage.idle:
        return 'Idle';
      case BuildStage.planning:
        return 'Planning';
      case BuildStage.generating:
        return 'Generating';
      case BuildStage.previewing:
        return 'Previewing';
      case BuildStage.complete:
        return 'Complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Realtime App Builder',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'AI plans, writes code, generates files, and streams previews.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StageChip(label: _stageLabel),
            const SizedBox(width: 12),
            SegmentedButton<FrameworkChoice>(
              segments: const [
                ButtonSegment(
                  value: FrameworkChoice.expo,
                  label: Text('Expo'),
                  icon: Icon(Icons.phone_android),
                ),
                ButtonSegment(
                  value: FrameworkChoice.react,
                  label: Text('React'),
                  icon: Icon(Icons.desktop_windows),
                ),
              ],
              selected: <FrameworkChoice>{frameworkChoice},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  onFrameworkChanged(selection.first);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _StageChip extends StatelessWidget {
  const _StageChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.bolt),
      label: Text(label),
    );
  }
}

class _ConfigCard extends StatelessWidget {
  const _ConfigCard({
    required this.projectController,
    required this.apiBaseController,
    required this.apiKeyController,
    required this.useE2B,
    required this.onToggleE2B,
  });

  final TextEditingController projectController;
  final TextEditingController apiBaseController;
  final TextEditingController apiKeyController;
  final bool useE2B;
  final ValueChanged<bool> onToggleE2B;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project + API Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Bring your own API and choose where preview workloads run.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: projectController,
              decoration: const InputDecoration(
                labelText: 'Project Name',
                prefixIcon: Icon(Icons.folder),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: apiBaseController,
              decoration: const InputDecoration(
                labelText: 'API Base URL',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                prefixIcon: Icon(Icons.vpn_key),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: useE2B,
              onChanged: onToggleE2B,
              title: const Text('Use E2B for preview sessions'),
              subtitle: const Text(
                'Provision sandboxed containers for live preview and terminal access.',
              ),
            ),
            const Divider(height: 32),
            _InfoRow(
              icon: Icons.auto_awesome,
              title: 'AI Workflow',
              description:
                  'The AI will think, write code, and generate files in realtime.',
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.cloud_sync,
              title: 'Live File Sync',
              description:
                  'Changes stream directly into the preview and terminal context.',
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.buildStage});

  final BuildStage buildStage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Preview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Stream Expo or React previews into this panel.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.desktop_mac,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _previewMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Preview'),
            ),
          ],
        ),
      ),
    );
  }

  String get _previewMessage {
    switch (buildStage) {
      case BuildStage.idle:
        return 'Preview will appear here once the AI build starts.';
      case BuildStage.planning:
        return 'Preparing preview environment...';
      case BuildStage.generating:
        return 'Generating app assets and preview entrypoint...';
      case BuildStage.previewing:
        return 'Streaming live preview from E2B.';
      case BuildStage.complete:
        return 'Preview ready. Open in a new window or device.';
    }
  }
}

class _TerminalCard extends StatelessWidget {
  const _TerminalCard({
    required this.commandController,
    required this.onRunCommand,
  });

  final TextEditingController commandController;
  final VoidCallback onRunCommand;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terminal',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Run commands inside the build sandbox.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              height: 160,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: const Text(
                '[32m$ Ready to run commands...\n$ npm run dev\n$ expo start[0m',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commandController,
                    decoration: const InputDecoration(
                      labelText: 'Command',
                      prefixIcon: Icon(Icons.terminal),
                    ),
                    onSubmitted: (_) => onRunCommand(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: onRunCommand,
                  child: const Text('Run'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activityLog});

  final List<String> activityLog;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tracks planning, file generation, and preview lifecycle events.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activityLog.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.bolt, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(activityLog[index]),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
