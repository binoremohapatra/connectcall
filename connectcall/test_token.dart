import 'package:agora_token_service/agora_token_service.dart';

void main() {
  final appId = '74ab349c3cbb41f0aab67dc9bb189a98';
  final appCert = 'ac4362c5978b473890de8963b5595d68';
  
  final token = RtcTokenBuilder.build(
    appId: appId,
    appCertificate: appCert,
    channelName: 'test_channel',
    uid: '0',
    role: RtcRole.publisher,
    privilegeExpiredTs: 3600,
  );
  
  print('Token: $token');
}
