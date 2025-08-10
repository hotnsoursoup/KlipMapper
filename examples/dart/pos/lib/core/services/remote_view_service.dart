// lib/core/services/remote_view_service.dart
// Provides real-time screen sharing capability using LiveKit WebRTC for remote POS viewing. Creates HTTP server with viewer interface and handles WebRTC room management for screen streaming.
// Usage: ORPHANED - Service exists but LiveKit dependencies are commented out and not currently used in the application
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'package:livekit_client/livekit_client.dart'; // COMMENTED OUT - REVISIT LATER
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import '../utils/logger.dart';

/// Real-time remote viewing service using LiveKit WebRTC
/// Implements proper screen sharing like RustDesk/TeamViewer with live video streaming
class RemoteViewService {
  static RemoteViewService? _instance;
  static RemoteViewService get instance => _instance ??= RemoteViewService._();
  
  RemoteViewService._();
  
  HttpServer? _server;
  // Room? _room; // COMMENTED OUT - REVISIT LATER
  // LocalVideoTrack? _screenTrack; // COMMENTED OUT - REVISIT LATER
  bool _isRunning = false;
  bool _isStreaming = false;
  int _port = 8080;
  String? _roomName;
  // LiveKit server configuration (you can use LiveKit Cloud or self-hosted)
  static const String _livekitUrl = 'wss://pos-demo.livekit.cloud';
  
  /// Start the remote viewing service
  Future<void> start({int port = 8080}) async {
    if (_isRunning) {
      Logger.warning('Remote view service already running');
      return;
    }
    
    _port = port;
    _roomName = 'pos-${_generateRoomId()}';
    
    try {
      // Start HTTP server for viewer interface
      final handler = Cascade()
          .add(_createApiHandler())
          .add(_createStaticHandler())
          .handler;
      
      _server = await io.serve(handler, '0.0.0.0', _port);
      _isRunning = true;
      
      // Initialize LiveKit room and start screen sharing
      // await _initializeLiveKitRoom(); // COMMENTED OUT - REVISIT LATER
      // await _startScreenSharing(); // COMMENTED OUT - REVISIT LATER
      
      Logger.info('Remote view service started on port $_port');
      Logger.info('Room: $_roomName');
      Logger.info('Viewer URL: http://localhost:$_port/viewer');
      
    } catch (e) {
      Logger.error('Failed to start remote view service: $e');
      throw Exception('Failed to start remote view service: $e');
    }
  }
  
  /// Stop the remote viewing service
  Future<void> stop() async {
    if (!_isRunning) return;
    
    // await _stopScreenSharing(); // COMMENTED OUT - REVISIT LATER
    // await _room?.disconnect(); // COMMENTED OUT - REVISIT LATER
    await _server?.close();
    
    // _room = null; // COMMENTED OUT - REVISIT LATER
    // _screenTrack = null; // COMMENTED OUT - REVISIT LATER
    _server = null;
    _isRunning = false;
    _isStreaming = false;
    
    Logger.info('Remote view service stopped');
  }
  
  /// Check if service is running
  bool get isRunning => _isRunning;
  
  /// Check if screen is being streamed
  bool get isStreaming => _isStreaming;
  
  /// Get viewer URL
  String? get viewerUrl => _isRunning ? 'http://localhost:$_port/viewer' : null;
  
  /// Get room name for connecting
  String? get roomName => _roomName;
  
  /// Get number of connected viewers
  int get connectedViewers => 0; // _room?.remoteParticipants.length ?? 0; // COMMENTED OUT - REVISIT LATER
  
  /// Initialize LiveKit room
  Future<void> _initializeLiveKitRoom() async {
    // COMMENTED OUT - REVISIT LATER
    /*
    try {
      // Check if LiveKit is properly configured
      if (_apiKey == 'your-api-key' || _apiSecret == 'your-api-secret') {
        Logger.warning('LiveKit not configured - skipping WebRTC functionality');
        Logger.info('To enable remote viewing, configure LiveKit credentials in remote_view_service.dart');
        return;
      }
      
      // Generate access token for screen sharing participant
      _accessToken = _generateAccessToken(_roomName!, 'pos-screen-share');
      
      // Create room with optimized settings for screen sharing
      _room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
          defaultCameraCaptureOptions: CameraCaptureOptions(
            maxFrameRate: 30,
          ),
          defaultScreenShareCaptureOptions: ScreenShareCaptureOptions(
            maxFrameRate: 15, // Optimized for screen sharing
          ),
        ),
      );
      
      // Set up room event listeners
      _room!.addListener(_onRoomEvent);
      
      // Connect to LiveKit server
      await _room!.connect(
        _livekitUrl,
        _accessToken!,
        connectOptions: const ConnectOptions(
          autoSubscribe: true,
        ),
      );
      
      Logger.info('Connected to LiveKit room: $_roomName');
      
    } catch (e) {
      // Handle different types of errors gracefully
      if (e.toString().contains('connectivity') || 
          e.toString().contains('MissingPluginException')) {
        Logger.warning('Connectivity plugin not available - remote viewing may be limited');
        Logger.warning('This is expected in WSL/headless environments');
        return;
      }
      
      if (e.toString().contains('invalid authorization token') || 
          e.toString().contains('401')) {
        Logger.warning('LiveKit authentication failed - placeholder credentials detected');
        Logger.info('Remote viewing will serve HTTP interface only');
        Logger.info('To enable WebRTC: Configure real LiveKit credentials and implement proper JWT signing');
        return;
      }
      
      Logger.error('Failed to initialize LiveKit room: $e');
      rethrow;
    }
    */
  }
  
  /// Start screen sharing
  Future<void> _startScreenSharing() async {
    // COMMENTED OUT - REVISIT LATER
    /*
    try {
      if (_room == null) {
        Logger.warning('LiveKit room not available - screen sharing disabled');
        return;
      }
      
      // Create screen share track
      _screenTrack = await LocalVideoTrack.createScreenShareTrack(
        const ScreenShareCaptureOptions(
          maxFrameRate: 15.0,
        ),
      );
      
      // Publish the screen share track
      await _room!.localParticipant?.publishVideoTrack(_screenTrack!);
      
      _isStreaming = true;
      Logger.info('Screen sharing started');
      
    } catch (e) {
      Logger.error('Failed to start screen sharing: $e');
      rethrow;
    }
    */
  }
  
  /// Stop screen sharing
  Future<void> _stopScreenSharing() async {
    // COMMENTED OUT - REVISIT LATER
    /*
    try {
      if (_screenTrack != null) {
        // Find the track publication and remove it using SID
        final publications = _room?.localParticipant?.trackPublications.values ?? [];
        for (final publication in publications) {
          if (publication.track == _screenTrack) {
            await _room?.localParticipant?.removePublishedTrack(publication.sid);
            break;
          }
        }
        
        await _screenTrack!.dispose();
        _screenTrack = null;
      }
      
      _isStreaming = false;
      Logger.info('Screen sharing stopped');
      
    } catch (e) {
      Logger.error('Failed to stop screen sharing: $e');
    }
    */
  }
  
  /// Handle room events
  void _onRoomEvent() {
    // COMMENTED OUT - REVISIT LATER
    /*
    final room = _room;
    if (room == null) return;
    
    room.addListener(() {
      // Log participant changes
      Logger.info('Room participants: ${room.remoteParticipants.length} viewers connected');
    });
    */
  }
  
  /// Generate unique room ID
  String _generateRoomId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999);
    return '${now.toString().substring(8)}_$random';
  }
  
  /// Generate LiveKit access token
  /// NOTE: In production, this should be done server-side for security
  String _generateAccessToken(String roomName, String participantName) {
    // IMPORTANT: This is a PLACEHOLDER implementation
    // Real LiveKit tokens require proper HMAC-SHA256 JWT signing with the API secret
    // 
    // To implement proper token generation:
    // 1. Add dart_jsonwebtoken package to pubspec.yaml
    // 2. Use JWT.sign() with HMAC-SHA256 and your API secret
    // 3. Or generate tokens server-side (recommended for production)
    //
    // For now, this just returns a placeholder that will cause 401 errors
    // which is handled gracefully by the service
    
    final payload = {
      'iss': _apiKey,
      'sub': participantName,
      'aud': 'livekit',
      'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600, // 1 hour
      'nbf': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'room': roomName,
      'permissions': {
        'canPublish': true,
        'canSubscribe': true,
        'canPublishData': true,
      },
    };
    
    // This is NOT a valid JWT - just base64 encoded JSON
    // Will result in 401 errors until proper JWT signing is implemented
    return base64Encode(utf8.encode(jsonEncode(payload)));
  }
  
  /// Generate viewer access token
  String _generateViewerToken(String roomName, String viewerId) {
    final payload = {
      'iss': _apiKey,
      'sub': viewerId,
      'aud': 'livekit',
      'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
      'nbf': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'room': roomName,
      'permissions': {
        'canPublish': false,
        'canSubscribe': true,
        'canPublishData': false,
      },
    };
    
    return base64Encode(utf8.encode(jsonEncode(payload)));
  }
  
  /// Create API handler for HTTP requests
  Handler _createApiHandler() {
    return (Request request) async {
      final path = request.url.path;
      
      switch (path) {
        case 'api/status':
          return _handleStatusRequest();
        case 'api/room-info':
          return _handleRoomInfoRequest();
        case 'api/viewer-token':
          return _handleViewerTokenRequest(request);
        default:
          return Response.notFound('API endpoint not found');
      }
    };
  }
  
  /// Create static file handler for viewer interface
  Handler _createStaticHandler() {
    return (Request request) async {
      if (request.url.path == 'viewer' || request.url.path == '') {
        return Response.ok(
          _generateViewerHtml(),
          headers: {'Content-Type': 'text/html'},
        );
      }
      return Response.notFound('Not found');
    };
  }
  
  /// Handle status request
  Response _handleStatusRequest() {
    final status = {
      'running': _isRunning,
      'streaming': _isStreaming,
      'port': _port,
      'roomName': _roomName,
      'connectedViewers': connectedViewers,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    return Response.ok(
      jsonEncode(status),
      headers: {'Content-Type': 'application/json'},
    );
  }
  
  /// Handle room info request
  Response _handleRoomInfoRequest() {
    if (!_isRunning || _roomName == null) {
      return Response.notFound(jsonEncode({'error': 'Service not running'}));
    }
    
    final roomInfo = {
      'roomName': _roomName,
      'livekitUrl': _livekitUrl,
      'isStreaming': _isStreaming,
    };
    
    return Response.ok(
      jsonEncode(roomInfo),
      headers: {'Content-Type': 'application/json'},
    );
  }
  
  /// Handle viewer token request
  Response _handleViewerTokenRequest(Request request) {
    if (!_isRunning || _roomName == null) {
      return Response.notFound(jsonEncode({'error': 'Service not running'}));
    }
    
    final viewerId = 'viewer_${DateTime.now().millisecondsSinceEpoch}';
    final token = _generateViewerToken(_roomName!, viewerId);
    
    final tokenInfo = {
      'token': token,
      'roomName': _roomName,
      'livekitUrl': _livekitUrl,
      'participantId': viewerId,
    };
    
    return Response.ok(
      jsonEncode(tokenInfo),
      headers: {'Content-Type': 'application/json'},
    );
  }
  
  /// Generate HTML viewer interface
  String _generateViewerHtml() {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POS Remote View - LiveKit</title>
    <script src="https://unpkg.com/livekit-client@2.5.0/dist/livekit-client.umd.js"></script>
    <style>
        body {
            margin: 0;
            padding: 20px;
            background: #1a1a1a;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .status {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .status-item {
            padding: 5px 10px;
            background: #333;
            border-radius: 5px;
        }
        .connected { background: #2d5a2d; }
        .streaming { background: #2d4a2d; }
        .screen-container {
            text-align: center;
            background: #2a2a2a;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.3);
        }
        #screen-video {
            max-width: 100%;
            max-height: 80vh;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.5);
            background: #333;
        }
        .controls {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        button {
            padding: 8px 16px;
            background: #0066cc;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        button:hover {
            background: #0052a3;
        }
        button:disabled {
            background: #666;
            cursor: not-allowed;
        }
        .error {
            color: #ff6b6b;
            text-align: center;
            padding: 20px;
        }
        .loading {
            text-align: center;
            padding: 40px;
        }
        .quality-info {
            font-size: 12px;
            color: #aaa;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🖥️ POS Remote View</h1>
        <p>Real-time WebRTC screen sharing powered by LiveKit</p>
    </div>
    
    <div class="status">
        <div class="status-item" id="connection-status">Connecting...</div>
        <div class="status-item" id="stream-status">No Stream</div>
        <div class="status-item" id="quality-status">Quality: --</div>
    </div>
    
    <div class="screen-container">
        <video id="screen-video" autoplay muted playsinline style="display: none;"></video>
        <div id="loading" class="loading">Connecting to POS screen...</div>
        <div id="error" class="error" style="display: none;"></div>
    </div>
    
    <div class="controls">
        <button onclick="reconnect()">Reconnect</button>
        <button onclick="toggleFullscreen()">Fullscreen</button>
        <button onclick="toggleMute()" id="mute-btn">Unmuted</button>
    </div>
    
    <div class="quality-info" id="quality-info">
        Resolution: -- | Framerate: -- | Bitrate: --
    </div>

    <script>
        let room = null;
        let isConnected = false;
        
        const screenVideo = document.getElementById('screen-video');
        const loading = document.getElementById('loading');
        const error = document.getElementById('error');
        const connectionStatus = document.getElementById('connection-status');
        const streamStatus = document.getElementById('stream-status');
        const qualityStatus = document.getElementById('quality-status');
        const qualityInfo = document.getElementById('quality-info');
        const muteBtn = document.getElementById('mute-btn');
        
        async function connect() {
            try {
                // Get room info and viewer token
                const tokenResponse = await fetch('/api/viewer-token');
                const tokenData = await tokenResponse.json();
                
                if (!tokenData.token) {
                    throw new Error('Failed to get access token');
                }
                
                // Create LiveKit room (check if LiveKitClient is available)
                let LK = LiveKitClient;
                if (typeof LiveKitClient === 'undefined') {
                    // Try alternative namespace
                    if (typeof window.LiveKit !== 'undefined') {
                        LK = window.LiveKit;
                    } else if (typeof window.livekit !== 'undefined') {
                        LK = window.livekit;
                    } else {
                        throw new Error('LiveKit client library not loaded - check browser console for errors');
                    }
                }
                
                room = new LK.Room({
                    adaptiveStream: true,
                    dynacast: true,
                });
                
                // Set up event listeners
                room.on('connected', onConnected);
                room.on('disconnected', onDisconnected);
                room.on('trackSubscribed', onTrackSubscribed);
                room.on('trackUnsubscribed', onTrackUnsubscribed);
                room.on('connectionQualityChanged', onQualityChanged);
                
                // Connect to room
                await room.connect(tokenData.livekitUrl, tokenData.token);
                
            } catch (e) {
                console.error('Connection failed:', e);
                showError('Failed to connect: ' + e.message);
            }
        }
        
        function onConnected() {
            isConnected = true;
            connectionStatus.textContent = 'Connected';
            connectionStatus.className = 'status-item connected';
            loading.textContent = 'Waiting for screen stream...';
            hideError();
        }
        
        function onDisconnected() {
            isConnected = false;
            connectionStatus.textContent = 'Disconnected';
            connectionStatus.className = 'status-item';
            streamStatus.textContent = 'No Stream';
            streamStatus.className = 'status-item';
            screenVideo.style.display = 'none';
            loading.style.display = 'block';
            loading.textContent = 'Disconnected. Click Reconnect.';
        }
        
        function onTrackSubscribed(track, publication, participant) {
            if (track.kind === 'video' && track.source === 'screen_share') {
                // Attach screen share track to video element
                track.attach(screenVideo);
                screenVideo.style.display = 'block';
                loading.style.display = 'none';
                
                streamStatus.textContent = 'Streaming';
                streamStatus.className = 'status-item streaming';
                
                console.log('Screen share track received from:', participant.identity);
            }
        }
        
        function onTrackUnsubscribed(track, publication, participant) {
            if (track.kind === 'video' && track.source === 'screen_share') {
                track.detach(screenVideo);
                screenVideo.style.display = 'none';
                loading.style.display = 'block';
                loading.textContent = 'Screen sharing stopped';
                
                streamStatus.textContent = 'No Stream';
                streamStatus.className = 'status-item';
            }
        }
        
        function onQualityChanged(quality, participant) {
            if (participant.isLocal) return;
            
            let qualityText = 'Excellent';
            // Get LiveKit namespace (same as connection function)
            let LK = LiveKitClient;
            if (typeof LiveKitClient === 'undefined') {
                if (typeof window.LiveKit !== 'undefined') {
                    LK = window.LiveKit;
                } else if (typeof window.livekit !== 'undefined') {
                    LK = window.livekit;
                }
            }
            
            if (quality === LK.ConnectionQuality.Good) qualityText = 'Good';
            else if (quality === LK.ConnectionQuality.Poor) qualityText = 'Poor';
            
            qualityStatus.textContent = `Quality: \${qualityText}`;
            
            // Update detailed quality info
            const tracks = Array.from(participant.videoTracks.values());
            if (tracks.length > 0) {
                const track = tracks[0];
                if (track.videoTrack) {
                    const stats = track.videoTrack.getStats();
                    if (stats) {
                        qualityInfo.textContent = `Resolution: \${stats.dimensions?.width || '--'}x\${stats.dimensions?.height || '--'} | Framerate: \${stats.frameRate || '--'} fps | Bitrate: \${Math.round((stats.bitrate || 0) / 1000)}kb/s`;
                    }
                }
            }
        }
        
        function showError(message) {
            error.textContent = message;
            error.style.display = 'block';
            loading.style.display = 'none';
        }
        
        function hideError() {
            error.style.display = 'none';
        }
        
        async function reconnect() {
            if (room) {
                await room.disconnect();
            }
            setTimeout(connect, 500);
        }
        
        function toggleFullscreen() {
            if (screenVideo.requestFullscreen) {
                screenVideo.requestFullscreen();
            } else if (screenVideo.webkitRequestFullscreen) {
                screenVideo.webkitRequestFullscreen();
            }
        }
        
        function toggleMute() {
            screenVideo.muted = !screenVideo.muted;
            muteBtn.textContent = screenVideo.muted ? 'Muted' : 'Unmuted';
        }
        
        // Start connection
        connect();
        
        // Handle page unload
        window.addEventListener('beforeunload', () => {
            if (room) {
                room.disconnect();
            }
        });
    </script>
</body>
</html>
    ''';
  }
}