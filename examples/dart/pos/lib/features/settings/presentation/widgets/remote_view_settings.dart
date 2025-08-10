// lib/features/settings/presentation/widgets/remote_view_settings.dart
// Remote view settings widget for configuring external display and remote monitoring features. Features remote view service integration, connection settings, and display configuration options.
// Usage: ACTIVE - Used in settings for remote view and external display configuration

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/remote_view_service.dart';

/// Settings widget for managing remote view capabilities
class RemoteViewSettings extends StatefulWidget {
  const RemoteViewSettings({super.key});

  @override
  State<RemoteViewSettings> createState() => _RemoteViewSettingsState();
}

class _RemoteViewSettingsState extends State<RemoteViewSettings> {
  final RemoteViewService _remoteViewService = RemoteViewService.instance;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.screen_share,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Remote View',
                  style: AppTextStyles.headline3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Allow remote viewing of the POS screen for support and monitoring',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Service Status
            _buildServiceStatus(),
            const SizedBox(height: 20),

            // Controls
            _buildControls(),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.errorRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.errorRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isRunning = _remoteViewService.isRunning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isRunning ? AppColors.successGreen : AppColors.textSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isRunning ? 'ACTIVE' : 'INACTIVE',
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceStatus() {
    if (!_remoteViewService.isRunning) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.visibility_off,
              color: AppColors.textSecondary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remote View Disabled',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Click "Start Remote View" to enable screen sharing',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.visibility,
                color: AppColors.successGreen,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remote View Active',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.successGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_remoteViewService.connectedViewers} viewer(s) connected',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAccessUrl(),
        ],
      ),
    );
  }

  Widget _buildAccessUrl() {
    final url = _remoteViewService.viewerUrl;
    if (url == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.link,
            color: AppColors.primaryBlue,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              url,
              style: AppTextStyles.bodySmall.copyWith(
                fontFamily: 'monospace',
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _copyToClipboard(url),
            icon: Icon(
              Icons.copy,
              color: AppColors.primaryBlue,
              size: 16,
            ),
            tooltip: 'Copy URL',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      children: [
        if (!_remoteViewService.isRunning) ...[
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _startRemoteView,
            icon: _isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(Icons.play_arrow, size: 18),
            label: Text(_isLoading ? 'Starting...' : 'Start Remote View'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _stopRemoteView,
            icon: _isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(Icons.stop, size: 18),
            label: Text(_isLoading ? 'Stopping...' : 'Stop Remote View'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _openViewer,
            icon: Icon(Icons.open_in_new, size: 18),
            label: Text('Open Viewer'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _startRemoteView() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _remoteViewService.start();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Remote view started successfully'),
            backgroundColor: AppColors.successGreen,
            action: SnackBarAction(
              label: 'Open Viewer',
              textColor: Colors.white,
              onPressed: _openViewer,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _stopRemoteView() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _remoteViewService.stop();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Remote view stopped'),
            backgroundColor: AppColors.warningOrange,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL copied to clipboard'),
          backgroundColor: AppColors.successGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _openViewer() {
    final url = _remoteViewService.viewerUrl;
    if (url != null) {
      // TODO: Launch URL in browser
      // This would require url_launcher package
      _copyToClipboard(url);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL copied - paste in browser to view'),
          backgroundColor: AppColors.primaryBlue,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}