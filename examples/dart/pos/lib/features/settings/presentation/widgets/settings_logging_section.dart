// lib/features/settings/presentation/widgets/settings_logging_section.dart
// Comprehensive logging configuration UI for admin control and troubleshooting
// Usage: ACTIVE - Admin interface for logging system management with remote capabilities

import 'package:flutter/material.dart';
import 'dart:convert';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/logging/log_level.dart';
import '../../../../../core/logging/logging_service.dart';
import '../../../shared/data/models/setting_model.dart';

class LoggingSection extends StatefulWidget {
  final Map<String, StoreSetting> settings;
  final Future<void> Function(String key, Object value) onUpdate;

  const LoggingSection({
    super.key,
    required this.settings,
    required this.onUpdate,
  });

  @override
  State<LoggingSection> createState() => _LoggingSectionState();
}

class _LoggingSectionState extends State<LoggingSection> {
  final LoggingService _loggingService = LoggingService.instance;
  Map<String, dynamic>? _loggingStats;
  bool _isLoadingStats = false;
  bool _troubleshootingMode = false;

  @override
  void initState() {
    super.initState();
    _loadLoggingStats();
  }

  Future<void> _loadLoggingStats() async {
    setState(() => _isLoadingStats = true);
    try {
      final stats = _loggingService.getLoggingStats();
      setState(() {
        _loggingStats = stats;
        _isLoadingStats = false;
      });
    } catch (e) {
      setState(() => _isLoadingStats = false);
    }
  }

  String _getString(String key, String defaultValue) {
    return widget.settings[key]?.value ?? defaultValue;
  }

  bool _getBool(String key, bool defaultValue) {
    final setting = widget.settings[key];
    if (setting == null) return defaultValue;
    return setting.value == 'true' || setting.value == '1';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current Status Card
        _buildStatusCard(),
        const SizedBox(height: 16),
        
        // Log Level Configuration
        _buildLogLevelTile(),
        const Divider(height: 1),
        
        // Destinations Configuration
        _buildDestinationsTile(),
        const Divider(height: 1),
        
        // Advanced Options
        _buildAdvancedOptionsTile(),
        const Divider(height: 1),
        
        // File Management
        _buildFileManagementTile(),
        const Divider(height: 1),
        
        // Remote Administration
        _buildRemoteAdminTile(),
        const Divider(height: 1),
        
        // Actions
        _buildActionsTile(),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Logging System Status',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (_isLoadingStats)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  onPressed: _loadLoggingStats,
                  tooltip: 'Refresh Stats',
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_loggingStats != null) ...[
            _buildStatRow('Session ID', _loggingStats!['sessionId'] ?? 'Unknown'),
            _buildStatRow('Device ID', (_loggingStats!['deviceId'] ?? 'Unknown').toString().substring(0, 20) + '...'),
            _buildStatRow('Logs Processed', _loggingStats!['totalLogsProcessed']?.toString() ?? '0'),
            _buildStatRow('Current Level', _loggingStats!['currentLevel'] ?? 'Unknown'),
            _buildStatRow('Active Destinations', (_loggingStats!['destinations'] as List?)?.join(', ') ?? 'Unknown'),
            if (_troubleshootingMode)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'TROUBLESHOOTING MODE ACTIVE',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.warningOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ] else
            const Text('Loading status...'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogLevelTile() {
    final currentLevel = _getString('logging_level', 'info');
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(
        'Log Level',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        'Minimum severity level for logging (lower levels ignored)',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          value: currentLevel.toUpperCase(),
          underline: const SizedBox.shrink(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          items: LogLevel.values.map((level) {
            return DropdownMenuItem<String>(
              value: level.label,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getLevelColor(level),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(level.label),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) async {
            if (value != null) {
              await widget.onUpdate('logging_level', value.toLowerCase());
              await _updateLoggingService();
            }
          },
        ),
      ),
    );
  }

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.trace:
        return Colors.grey;
      case LogLevel.debug:
        return Colors.cyan;
      case LogLevel.info:
        return Colors.green;
      case LogLevel.warn:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.fatal:
        return Colors.purple;
    }
  }

  Widget _buildDestinationsTile() {
    return ExpansionTile(
      title: Text(
        'Log Destinations',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        'Where logs are written (multiple destinations supported)',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      children: [
        _buildSwitchListTile(
          'Console Output',
          'Write logs to console/debug output',
          'logging_console_enabled',
          true,
        ),
        _buildSwitchListTile(
          'File Storage',
          'Write logs to local files with rotation',
          'logging_file_enabled',
          true,
        ),
        _buildSwitchListTile(
          'Remote Logging',
          'Send logs to remote API (when available)',
          'logging_remote_enabled',
          false,
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 40, right: 20, top: 4, bottom: 4),
          title: Text(
            'Memory Buffer',
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
          ),
          subtitle: Text(
            'Always enabled for diagnostics and remote access',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'ENABLED',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.successGreen,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedOptionsTile() {
    return ExpansionTile(
      title: Text(
        'Advanced Options',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        'Performance and detail settings (may impact performance)',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      children: [
        _buildSwitchListTile(
          'Verbose Console',
          'Show detailed log format in console',
          'logging_verbose_console',
          false,
        ),
        _buildSwitchListTile(
          'Include Stack Traces',
          'Add stack traces to error logs (performance impact)',
          'logging_include_stack_trace',
          true,
        ),
        _buildSwitchListTile(
          'Include Method Names',
          'Add method names to logs (performance impact)',
          'logging_include_method_names',
          false,
        ),
        _buildSwitchListTile(
          'Async Logging',
          'Use asynchronous logging for better performance',
          'logging_async_enabled',
          true,
        ),
      ],
    );
  }

  Widget _buildFileManagementTile() {
    return ExpansionTile(
      title: Text(
        'File Management',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        'Log file rotation, size limits, and cleanup settings',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      children: [
        _buildNumberInputTile(
          'Max File Size (MB)',
          'Maximum size before rotating log file',
          'logging_max_file_size',
          10,
          minValue: 1,
          maxValue: 100,
        ),
        _buildNumberInputTile(
          'Max File Count',
          'Number of rotated log files to keep',
          'logging_max_file_count',
          5,
          minValue: 1,
          maxValue: 20,
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
          title: Text(
            'Current Log File',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            _loggingStats?['currentLogFile']?.toString().split('/').last ?? 'No file active',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          trailing: TextButton(
            onPressed: _openLogFile,
            child: const Text('View'),
          ),
        ),
      ],
    );
  }

  Widget _buildRemoteAdminTile() {
    return ExpansionTile(
      title: Text(
        'Remote Administration',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        'Remote troubleshooting and log access controls',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(
            'Enable Troubleshooting Mode',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            'Maximum verbosity for remote troubleshooting',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          trailing: ElevatedButton(
            onPressed: _troubleshootingMode ? null : _enableTroubleshooting,
            style: ElevatedButton.styleFrom(
              backgroundColor: _troubleshootingMode 
                  ? Colors.grey 
                  : AppColors.warningOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(_troubleshootingMode ? 'ACTIVE' : 'Enable'),
          ),
        ),
        if (_troubleshootingMode)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            title: Text(
              'Disable Troubleshooting',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            trailing: ElevatedButton(
              onPressed: _disableTroubleshooting,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Disable'),
            ),
          ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(
            'Export Logs',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            'Export recent logs for remote analysis',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          trailing: ElevatedButton(
            onPressed: _exportLogs,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Export'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsTile() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _testLogging,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Test Logging'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _clearLogs,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('Clear Logs'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchListTile(String title, String subtitle, String settingKey, bool defaultValue) {
    final value = _getBool(settingKey, defaultValue);
    
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40, right: 20, top: 4, bottom: 4),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: (newValue) async {
          await widget.onUpdate(settingKey, newValue);
          await _updateLoggingService();
        },
        thumbColor: WidgetStatePropertyAll<Color>(AppColors.primaryBlue),
      ),
    );
  }

  Widget _buildNumberInputTile(String title, String subtitle, String settingKey, int defaultValue, {int minValue = 1, int maxValue = 100}) {
    final currentValue = int.tryParse(_getString(settingKey, defaultValue.toString())) ?? defaultValue;
    
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40, right: 20, top: 8, bottom: 8),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: SizedBox(
        width: 80,
        child: TextFormField(
          initialValue: currentValue.toString(),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          onChanged: (value) async {
            final numValue = int.tryParse(value);
            if (numValue != null && numValue >= minValue && numValue <= maxValue) {
              await widget.onUpdate(settingKey, numValue);
              await _updateLoggingService();
            }
          },
        ),
      ),
    );
  }

  Future<void> _updateLoggingService() async {
    try {
      final settingsMap = {
        'logging_level': _getString('logging_level', 'info'),
        'logging_console_enabled': _getBool('logging_console_enabled', true).toString(),
        'logging_file_enabled': _getBool('logging_file_enabled', true).toString(),
        'logging_remote_enabled': _getBool('logging_remote_enabled', false).toString(),
        'logging_verbose_console': _getBool('logging_verbose_console', false).toString(),
        'logging_include_stack_trace': _getBool('logging_include_stack_trace', true).toString(),
        'logging_include_method_names': _getBool('logging_include_method_names', false).toString(),
        'logging_async_enabled': _getBool('logging_async_enabled', true).toString(),
        'logging_max_file_size': _getString('logging_max_file_size', '10'),
        'logging_max_file_count': _getString('logging_max_file_count', '5'),
      };

      await _loggingService.updateFromSettings(settingsMap);
      await _loadLoggingStats();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update logging configuration: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _enableTroubleshooting() async {
    try {
      await _loggingService.enableTroubleshootingMode(durationMinutes: 30);
      setState(() => _troubleshootingMode = true);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Troubleshooting mode enabled (30 minutes)'),
            backgroundColor: AppColors.warningOrange,
          ),
        );
      }

      // Auto-disable after 30 minutes
      Future.delayed(const Duration(minutes: 30), () {
        if (mounted) {
          setState(() => _troubleshootingMode = false);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to enable troubleshooting: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _disableTroubleshooting() async {
    try {
      await _loggingService.disableTroubleshootingMode();
      setState(() => _troubleshootingMode = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Troubleshooting mode disabled'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to disable troubleshooting: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _exportLogs() async {
    try {
      final logs = await _loggingService.exportLogs(maxEntries: 1000);
      
      // Convert to JSON string for sharing
      final jsonLogs = jsonEncode(logs);
      
      // TODO: Implement sharing/saving functionality
      // For now, show a dialog with log count
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logs Exported'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${logs.length} log entries exported.'),
                const SizedBox(height: 8),
                Text('JSON size: ${jsonLogs.length} characters'),
                const SizedBox(height: 16),
                const Text('TODO: Implement file saving or sharing.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export logs: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _testLogging() async {
    try {
      // Test all log levels with the logging service
      final testMessage = 'Logging test from settings UI';
      final testData = {
        'source': 'settings_ui',
        'testType': 'manual_test',
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      // Generate test logs at all levels through the service
      await _loggingService.testAllLogLevels(testMessage, testData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Test logs generated at all levels'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate test logs: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
    
    await _loadLoggingStats();
  }

  Future<void> _clearLogs() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Logs'),
        content: const Text('This will clear all log files and memory buffer. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _loggingService.clearAllLogs();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('All logs cleared successfully'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
        
        await _loadLoggingStats();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to clear logs: $e'),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      }
    }
  }

  Future<void> _openLogFile() async {
    try {
      final recentLogs = await _loggingService.getRecentLogEntries(limit: 50);
      
      if (!mounted) return;
      
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Recent Log Entries'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: recentLogs.isEmpty
                ? const Center(
                    child: Text('No log entries found'),
                  )
                : ListView.builder(
                    itemCount: recentLogs.length,
                    itemBuilder: (context, index) {
                      final log = recentLogs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _getLevelColor(LogLevel.fromString(log['level']) ?? LogLevel.info),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${log['timestamp']?.toString().substring(11, 19) ?? ''} [${log['level'] ?? ''}]',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                log['message']?.toString() ?? '',
                                style: const TextStyle(fontSize: 13),
                              ),
                              if (log['data'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Data: ${log['data'].toString()}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load log entries: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }
}
