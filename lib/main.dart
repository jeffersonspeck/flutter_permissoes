import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const PermissionsDemoApp());
}

class PermissionsDemoApp extends StatelessWidget {
  const PermissionsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permissões Android (Demo)',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const PermissionsHomePage(),
    );
  }
}

class PermissionsHomePage extends StatefulWidget {
  const PermissionsHomePage({super.key});

  @override
  State<PermissionsHomePage> createState() => _PermissionsHomePageState();
}

class _PermissionsHomePageState extends State<PermissionsHomePage> {
  String cameraStatus = 'desconhecido';
  String overlayStatus = 'desconhecido';

  Future<void> _checkCamera() async {
    final status = await Permission.camera.status;
    setState(() => cameraStatus = status.toString());
  }

  Future<void> _requestCamera() async {
    final status = await Permission.camera.request();
    setState(() => cameraStatus = status.toString());
  }

  Future<void> _checkOverlay() async {
    final status = await Permission.systemAlertWindow.status;
    setState(() => overlayStatus = status.toString());
  }

  Future<void> _requestOverlay() async {
    // Para permissões especiais, o plugin abre a tela de configurações apropriada.
    final status = await Permission.systemAlertWindow.request();
    setState(() => overlayStatus = status.toString());
  }

  void _explainSignaturePermission() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Signature permissions'),
        content: const Text(
          'Permissões nível "signature" só são concedidas a apps assinados '
          'com a mesma chave que definiu a permissão (sistema/OEM). '
          'Apps de terceiros não podem solicitá-las. '
          'Ex.: READ_PRIVILEGED_PHONE_STATE.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> actions,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(subtitle),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: actions),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkCamera();
    _checkOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissões: dangerous vs special vs signature')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tile(
            icon: Icons.photo_camera_outlined,
            title: 'Dangerous permission: CAMERA',
            subtitle: 'Pedido em tempo de execução. Status: $cameraStatus',
            actions: [
              ElevatedButton.icon(
                onPressed: _checkCamera,
                icon: const Icon(Icons.refresh),
                label: const Text('Checar CAMERA'),
              ),
              FilledButton.icon(
                onPressed: _requestCamera,
                icon: const Icon(Icons.lock_open),
                label: const Text('Pedir CAMERA (runtime)'),
              ),
            ],
          ),
          _tile(
            icon: Icons.filter_none,
            title: 'Special permission: SYSTEM_ALERT_WINDOW (overlay)',
            subtitle:
                'Concedida via Configurações do sistema (Acesso especial). Status: $overlayStatus',
            actions: [
              ElevatedButton.icon(
                onPressed: _checkOverlay,
                icon: const Icon(Icons.refresh),
                label: const Text('Checar overlay'),
              ),
              FilledButton.icon(
                onPressed: _requestOverlay,
                icon: const Icon(Icons.settings),
                label: const Text('Abrir concessão overlay'),
              ),
            ],
          ),
          _tile(
            icon: Icons.verified_user_outlined,
            title: 'Signature permission (ex.: READ_PRIVILEGED_PHONE_STATE)',
            subtitle:
                'Apenas para apps com a mesma assinatura do sistema/OEM. Terceiros não podem solicitar.',
            actions: [
              FilledButton.tonalIcon(
                onPressed: _explainSignaturePermission,
                icon: const Icon(Icons.info_outline),
                label: const Text('Entender por que não é possível'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Demonstração didática:\n'
            '• Dangerous → declara no Manifest + pede em runtime.\n'
            '• Special → geralmente configurações do sistema / app-ops; sem prompt padrão.\n'
            '• Signature → indisponível para apps comuns.',
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
