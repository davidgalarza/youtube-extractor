import 'adaptive_stream_info_parser.dart';
import 'muxed_stream_info_parser.dart';

class VideoInfoParser {
  Map<String, String> _root;

  VideoInfoParser(this._root);

  String parseId() => _root["video_id"];

  int parseErrorCode() =>
      _root['errorcode'] == null ? 0 : int.tryParse(_root['errorcode']);

  String parseErrorReason() => _root["reason"];

  String parsePreviewVideoId() => _root['ypc_vid'];

  String parseDashManifestUrl() => _root["dashmpd"];

  String parseHlsPlaylistUrl() => _root["hlsvp"];

  List<MuxedStreamInfoParser> getMuxedStreamInfo() {
    var streamInfosEncoded = _root['url_encoded_fmt_stream_map'];

    if (streamInfosEncoded == null) {
      return List<MuxedStreamInfoParser>();
    }

    // List that we will full
    var builtList = List<MuxedStreamInfoParser>();

    // Extract the streams and return a list
    var streams = streamInfosEncoded.split(',');
    streams.forEach((stream) {
      builtList.add(MuxedStreamInfoParser(Uri.splitQueryString(stream)));
    });

    return builtList;
  }

  List<AdaptiveStreamInfoParser> getAdaptiveStreamInfo() {
    var streamInfosEncoded = _root['adaptive_fmts'];

    if (streamInfosEncoded == null) {
      return List<AdaptiveStreamInfoParser>();
    }

    // List that we will full
    var builtList = List<AdaptiveStreamInfoParser>();

    // Extract the streams and return a list
    var streams = streamInfosEncoded.split(',');
    streams.forEach((stream) {
      builtList.add(AdaptiveStreamInfoParser(Uri.splitQueryString(stream)));
    });

    return builtList;
  }

  static VideoInfoParser initialize(String raw) {
    var root = Uri.splitQueryString(raw);
    return VideoInfoParser(root);
  }
}
