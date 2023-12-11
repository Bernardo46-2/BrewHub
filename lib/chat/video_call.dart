import 'dart:convert';

import 'package:brewhub/models/friend.dart';
import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:clipboard/clipboard.dart';
import 'dart:math' as math;

class VideoCallScreen extends StatefulWidget {
  final Friend friend;

  const VideoCallScreen({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _isFrontCamera = true;

  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();
  final sdpController = TextEditingController();

  bool _offer = false;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  initRenderer() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();

    _localVideoRenderer.addListener(_onRenderLocal);
    _remoteVideoRenderer.addListener(_onRenderRemote);
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localVideoRenderer.srcObject = stream;
    return stream;
  }

  _createPeerConnecion() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    _localStream!.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onTrack = (RTCTrackEvent event) {
      print(
          ' ________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________');
      if (event.streams.isNotEmpty) {
        print(
            ' ________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________ Track added: ${event.track.id}');
        _remoteVideoRenderer.srcObject = event.streams.first;
        for (var stream in event.streams) {
          print(stream);
        }
        print("_____________________________________________");
      }
    };

    return pc;
  }

  void _createOffer() async {
    print('peerConnection = ${_peerConnection}');
    RTCSessionDescription description =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp.toString());
    print(
        "______________________________________________________ CREATE OFFER ______________________________________________________");
    String offer = json.encode(session);
    print(offer);
    print(
        "______________________________________________________ CREATE OFFER ______________________________________________________");
    _offer = true;

    FlutterClipboard.copy(offer).then((value) => print('Copied to clipboard'));

    _peerConnection!.setLocalDescription(description);
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

    var session = parse(description.sdp.toString());
    print(
        "______________________________________________________ CREATE ANSWER ______________________________________________________");
    String encodedSession = json.encode(session);
    print(encodedSession);
    print(
        "______________________________________________________ CREATE ANSWER ______________________________________________________");

    FlutterClipboard.copy(encodedSession)
        .then((value) => print('Copied to clipboard'));

    _peerConnection!.setLocalDescription(description);
  }

  void _setRemoteDescription() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode(jsonString);

    String sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

    print(
        "______________________________________________________ SET REMOTE DESCRIPTION ______________________________________________________");
    print(description.toMap());
    print(
        "______________________________________________________ SET REMOTE DESCRIPTION ______________________________________________________");

    await _peerConnection!.setRemoteDescription(description);
  }

  void _addCandidate() async {
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode(jsonString);
    print(
        "______________________________________________________ ADD CANDIDATE ______________________________________________________");
    print(session['candidate']);
    print(
        "______________________________________________________ ADD CANDIDATE ______________________________________________________");
    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection!.addCandidate(candidate);
  }

  @override
  void initState() {
    initRenderer();
    _createPeerConnecion().then((pc) {
      _peerConnection = pc;
    });
    super.initState();
  }

  @override
  void dispose() async {
    /* sdpController.dispose();

    _localVideoRenderer.srcObject?.getTracks().forEach((track) {
      track.stop();
    });
    _remoteVideoRenderer.srcObject?.getTracks().forEach((track) {
      track.stop();
    });

    await _localVideoRenderer.dispose();
    await _remoteVideoRenderer.dispose();
    super.dispose(); */

    await _localVideoRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  _onRenderLocal() {
    _onRendererUpdate(_localVideoRenderer);
  }

  _onRenderRemote() {
    _onRendererUpdate(_remoteVideoRenderer);
  }

  void _onRendererUpdate(RTCVideoRenderer videoRenderer) {
    if (videoRenderer.videoWidth > 0 && videoRenderer.videoHeight > 0) {
      if (videoRenderer == _localVideoRenderer) {
        videoRenderer.removeListener(_onRenderLocal);
      } else {
        videoRenderer.removeListener(_onRenderRemote);
      }
      setState(() {});
    }
  }

  Widget _buildVideoView(RTCVideoRenderer videoRenderer, bool isLocal) {
    var videoView = Positioned.fill(
      child: videoRenderer.videoWidth > 0 && videoRenderer.videoHeight > 0
          ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: videoRenderer.videoWidth.toDouble(),
                height: videoRenderer.videoHeight.toDouble(),
                child: RTCVideoView(videoRenderer, mirror: isLocal),
              ))
          : const Center(child: CircularProgressIndicator()),
    );

    if (isLocal) {
      return GestureDetector(
        onTap: _switchCameraViews,
        child: videoView,
      );
    } else {
      return videoView;
    }
  }

  void _toggleCamera() {
    if (_localStream != null) {
      bool isVideoTrackEnabled = _localStream!.getVideoTracks().first.enabled;
      setState(() {
        _localStream!.getVideoTracks().first.enabled = !isVideoTrackEnabled;
        _isCameraOff = !_isCameraOff;
      });
    }
  }

  void _toggleMute() {
    /* if (_localStream != null) {
      bool isAudioTrackEnabled = _localStream!.getAudioTracks().first.enabled;
      setState(() {
        _localStream!.getAudioTracks().first.enabled = !isAudioTrackEnabled;
        _isMuted = !_isMuted;
      });
    } */
  }

  void _switchCameraViews() {
    var tempStream = _localVideoRenderer.srcObject;
    _localVideoRenderer.srcObject = _remoteVideoRenderer.srcObject;
    _remoteVideoRenderer.srcObject = tempStream;
  }

  void _switchCamera() async {
    // Encontra a câmera que não está sendo usada atualmente.
    String newCameraDirection = 'user';
    if (_localStream!.getVideoTracks().isNotEmpty) {
      final videoTrack = _localStream!.getVideoTracks().first;
      String currentFacingMode = videoTrack.getSettings()['facingMode'];
      newCameraDirection = currentFacingMode == 'user' ? 'environment' : 'user';

      // Para o rastreamento atual
      videoTrack.stop();
    }

    // Obtém o novo fluxo de mídia com a câmera alternada.
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': newCameraDirection,
      }
    };

    MediaStream newStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    // Substitui o rastreamento atual pelo novo.
    _localVideoRenderer.srcObject = newStream;
    _localStream = newStream;

    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  SizedBox videoRenderers() => SizedBox(
        height: 210,
        child: Row(children: [
          Flexible(
            child: Container(
              key: const Key('local'),
              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_localVideoRenderer),
            ),
          ),
          Flexible(
            child: Container(
              key: const Key('remote'),
              margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_remoteVideoRenderer),
            ),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark3,
      body: Stack(
        children: [
          // Representação da tela de chamada
          // Vídeo do usuário (Renderização do WebRTC)
          _buildVideoView(_remoteVideoRenderer, false),
          // Vídeo local (pequeno)
          Positioned(
            right: 16,
            top: 50,
            child: SizedBox(
              width: 100,
              height: 150,
              child: _buildVideoView(_localVideoRenderer, true),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                rtcContorls(),
                microfone(),
                camera(),
                // switchCamera(),
                desligar(context),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.friend.getFriendImage(),
                  radius: 23,
                ),
                const SizedBox(width: 10),
                Text(widget.friend.name,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container switchCamera() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: const BoxDecoration(
        color: dark2_75, // Cor semitransparente
        shape: BoxShape.circle, // Formato circular
      ),
      child: IconButton(
        icon: Transform(
          alignment: Alignment.center,
          // Inverte o ícone quando a câmera frontal não estiver ativa
          transform:
              _isFrontCamera ? Matrix4.identity() : Matrix4.rotationY(math.pi),
          child: const Icon(
            Icons.cameraswitch,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          _switchCamera();
        },
      ),
    );
  }

  Container camera() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: const BoxDecoration(
        color: dark2_75, // Cor semitransparente
        shape: BoxShape.circle, // Formato circular
      ),
      child: IconButton(
        icon: Icon(
          _isCameraOff ? Icons.videocam_off : Icons.videocam,
          color: Colors.white,
        ),
        onPressed: () {
          _toggleCamera();
        },
      ),
    );
  }

  Container desligar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: const BoxDecoration(
        color: dark2_75, // Cor semitransparente
        shape: BoxShape.circle, // Formato circular
      ),
      child: IconButton(
        icon: const Icon(
          Icons.call_end,
          color: Colors.red,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Container microfone() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: const BoxDecoration(
        color: dark2_75, // Cor semitransparente
        shape: BoxShape.circle, // Formato circular
      ),
      child: IconButton(
        icon: Icon(
          _isMuted ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
        onPressed: () {
          _toggleMute();
        },
      ),
    );
  }

  Container rtcContorls() {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: const BoxDecoration(
        color: dark2_75, // Cor semitransparente
        shape: BoxShape.circle, // Formato circular
      ),
      child: IconButton(
        icon: const Icon(
          Icons.webhook,
          color: Colors.white,
        ),
        onPressed: () {
          _showWebRTCControls(context);
        },
      ),
    );
  }

  void _showWebRTCControls(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: dark3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 6),
                TextField(
                  controller: sdpController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  maxLength: TextField.noMaxLength,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: dark7,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                ElevatedButton(
                  onPressed: _createOffer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark4,
                    foregroundColor: primary6,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Offer"),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _createAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark4,
                    foregroundColor: primary6,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Answer"),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _setRemoteDescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark4,
                    foregroundColor: primary6,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Set Remote Description"),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _addCandidate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark4,
                    foregroundColor: primary6,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Set Candidate"),
                ),
              ],
            ),
          );
        });
  }
}
