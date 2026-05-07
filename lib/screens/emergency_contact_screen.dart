import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  // 전화 앱 열기 (자동 발신 아님 X, 번호 입력 상태 O)
  Future<void> _openPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    // launchUrl은 기본적으로 '다이얼 화면'까지만 
    // 안드로이드/iOS 정책상 사용자가 직접 통화 버튼을 눌러야 연결됨
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('전화 앱을 열 수 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '긴급 연락처',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            '카드를 누르면 전화 앱으로 이동합니다.\n번호가 입력된 상태에서 통화 버튼을 눌러주세요.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // 1. 경찰서 (112)
          _buildEmergencyCard(
            context,
            title: '경찰서',
            subTitle: '범죄 신고 및 위급 상황',
            number: '112',
            icon: Icons.local_police,
            color: Colors.red[700]!,
          ),

          const SizedBox(height: 16),

          // 2. 여성긴급전화 (1366)
          _buildEmergencyCard(
            context,
            title: '여성긴급전화 (해바라기센터)',
            subTitle: '가정폭력·성폭력·스토킹 등 긴급 상담',
            number: '1366',
            icon: Icons.support_agent,
            color: Colors.orange[700]!,
          ),

          const SizedBox(height: 16),

          // 3. 소방서 (119)
          _buildEmergencyCard(
            context,
            title: '소방서',
            subTitle: '화재·구조·구급 상황',
            number: '119',
            icon: Icons.fire_truck,
            color: Colors.red[900]!,
          ),
        ],
      ),
    );
  }

  // 카드 디자인 위젯
  Widget _buildEmergencyCard(
      BuildContext context, {
        required String title,
        required String subTitle,
        required String number,
        required IconData icon,
        required Color color,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _openPhoneDialer(number), // 클릭 시 다이얼 화면으로 이동
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              // 아이콘
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),

              // 텍스트 (제목, 설명)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // 전화번호 표시
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.call, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      number,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}