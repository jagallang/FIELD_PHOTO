import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '설정',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 앱 정보 섹션
              _buildSectionCard(
                title: '앱 정보',
                children: [
                  _buildListTile(
                    icon: Icons.info_outline,
                    title: 'REphoto',
                    subtitle: '버전 ${AppConstants.appVersion}',
                    onTap: () => _showAboutDialog(context),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.privacy_tip_outlined,
                    title: '개인정보처리방침',
                    subtitle: '개인정보 보호 및 처리 방침',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 기능 설정 섹션
              _buildSectionCard(
                title: '기능 설정',
                children: [
                  _buildListTile(
                    icon: Icons.language,
                    title: '언어 설정',
                    subtitle: '한국어',
                    onTap: () => _showLanguageDialog(context),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.photo_size_select_actual,
                    title: '기본 저장 품질',
                    subtitle: '높음',
                    onTap: () => _showQualityDialog(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 지원 섹션
              _buildSectionCard(
                title: '지원',
                children: [
                  _buildListTile(
                    icon: Icons.help_outline,
                    title: '도움말',
                    subtitle: '앱 사용법 및 FAQ',
                    onTap: () => _showHelpDialog(context),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.feedback_outlined,
                    title: '피드백 보내기',
                    subtitle: '의견 및 개선사항 제안',
                    onTap: () => _showFeedbackDialog(context),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // 앱 정보 푸터
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'REphoto',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '사진을 예술로 만드는 폴라로이드 프레임 앱',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© 2024 REphoto. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
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
  
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: const Color(0xFF1976D2),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
  
  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 68,
      endIndent: 16,
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('REphoto 정보'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('버전: ${AppConstants.appVersion}'),
              SizedBox(height: 8),
              Text('사진을 예술로 만드는 폴라로이드 프레임 앱'),
              SizedBox(height: 16),
              Text('기능:'),
              Text('• 사진에 폴라로이드 프레임 추가'),
              Text('• 다양한 레이아웃 제공'),
              Text('• 사진 확대/축소/회전'),
              Text('• PDF 생성 및 공유'),
              Text('• 고품질 이미지 저장'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('언어 설정'),
        content: const Text('현재 한국어만 지원됩니다.\n향후 업데이트에서 다국어 지원이 추가될 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  
  void _showQualityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('저장 품질'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('높음'),
              leading: Radio<String>(
                value: '높음',
                groupValue: '높음',
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
            ListTile(
              title: const Text('중간'),
              leading: Radio<String>(
                value: '중간',
                groupValue: '높음',
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
            ListTile(
              title: const Text('낮음'),
              leading: Radio<String>(
                value: '낮음',
                groupValue: '높음',
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }
  
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('도움말'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '사용법:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. 빈 슬롯을 터치하여 사진 선택'),
              Text('2. 사진을 터치하여 확대/축소/회전'),
              Text('3. 제목을 터치하여 편집'),
              Text('4. 저장 버튼을 눌러 갤러리에 저장'),
              SizedBox(height: 16),
              Text(
                'FAQ:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Q: 사진이 저장되지 않아요'),
              Text('A: 저장소 권한을 확인해 주세요'),
              SizedBox(height: 8),
              Text('Q: 사진 품질이 낮아요'),
              Text('A: 설정에서 저장 품질을 높음으로 변경하세요'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  
  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('피드백'),
        content: const Text('Google Play 스토어의 REphoto 앱 페이지에서 리뷰를 남겨주세요.\n\n여러분의 소중한 의견이 앱 개선에 큰 도움이 됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '개인정보처리방침',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'REphoto 개인정보처리방침',
              isMain: true,
            ),
            _buildText('시행일자: 2024년 8월 24일', isBold: true),
            
            const SizedBox(height: 24),
            
            _buildSection(title: '1. 개인정보의 수집 및 이용목적'),
            _buildText('REphoto 앱은 다음의 목적으로 개인정보를 처리합니다:'),
            
            _buildSubSection(title: '1.1 필수 정보'),
            _buildBulletPoint('사진 및 미디어 파일: 사용자가 선택한 사진에 프레임을 추가하고 편집된 이미지를 저장하기 위함'),
            _buildBulletPoint('저장소 접근: 편집된 사진을 사용자 기기에 저장하기 위함'),
            
            _buildSubSection(title: '1.2 선택적 정보'),
            _buildText('현재 REphoto 앱은 선택적 개인정보를 수집하지 않습니다.'),
            
            _buildSection(title: '2. 수집하는 개인정보 항목'),
            
            _buildSubSection(title: '2.1 자동 수집 정보'),
            _buildText('REphoto 앱은 다음과 같은 개인정보를 수집하지 않습니다:', isBold: true),
            _buildBulletPoint('개인식별정보 (이름, 이메일, 전화번호 등)'),
            _buildBulletPoint('위치정보'),
            _buildBulletPoint('기기 고유 식별정보'),
            _buildBulletPoint('사용 통계 또는 분석 데이터'),
            
            _buildSubSection(title: '2.2 사용자 제공 정보'),
            _buildBulletPoint('사진 파일: 사용자가 직접 선택한 사진 파일 (앱 내에서만 처리되며 외부로 전송되지 않음)'),
            
            _buildSection(title: '3. 개인정보의 처리 및 보유기간'),
            
            _buildSubSection(title: '3.1 처리 방법'),
            _buildBulletPoint('모든 사진 처리는 사용자 기기 내에서만 수행됩니다'),
            _buildBulletPoint('사진 데이터는 외부 서버로 전송되지 않습니다'),
            _buildBulletPoint('편집된 사진은 사용자가 지정한 기기 저장소에만 저장됩니다'),
            
            _buildSubSection(title: '3.2 보유기간'),
            _buildBulletPoint('REphoto 앱은 사진 데이터를 별도로 저장하거나 보유하지 않습니다'),
            _buildBulletPoint('사용자가 선택한 원본 사진과 편집된 사진은 사용자 기기에만 존재합니다'),
            
            _buildSection(title: '4. 개인정보의 제3자 제공'),
            _buildText('REphoto 앱은 사용자의 개인정보를 제3자에게 제공하지 않습니다.'),
            
            _buildSection(title: '5. 개인정보의 안전성 확보조치'),
            
            _buildSubSection(title: '5.1 기술적 조치'),
            _buildBulletPoint('모든 사진 처리는 기기 내부에서만 수행'),
            _buildBulletPoint('네트워크를 통한 데이터 전송 없음'),
            _buildBulletPoint('앱 샌드박스 환경에서 안전한 데이터 처리'),
            
            _buildSubSection(title: '5.2 물리적 조치'),
            _buildBulletPoint('사용자 기기의 보안 설정에 따라 데이터 보호'),
            
            _buildSection(title: '6. 사용자 권리'),
            
            _buildSubSection(title: '6.1 접근권'),
            _buildText('사용자는 언제든지 자신의 사진에 접근할 수 있습니다'),
            
            _buildSubSection(title: '6.2 삭제권'),
            _buildBulletPoint('사용자는 언제든지 편집된 사진을 삭제할 수 있습니다'),
            _buildBulletPoint('앱 삭제 시 모든 관련 데이터가 함께 삭제됩니다'),
            
            _buildSection(title: '7. 권한 사용 안내'),
            
            _buildSubSection(title: '7.1 필수 권한'),
            _buildBulletPoint('저장소 접근 권한: 사진 선택 및 편집된 이미지 저장을 위해 필요'),
            _buildBulletPoint('카메라 권한: 새로운 사진 촬영 기능을 위해 필요 (선택사항)'),
            
            _buildSubSection(title: '7.2 권한 거부 시'),
            _buildBulletPoint('저장소 접근 권한 거부 시: 사진 선택 및 저장 기능 사용 불가'),
            _buildBulletPoint('카메라 권한 거부 시: 촬영 기능 사용 불가 (기본 기능은 정상 작동)'),
            
            _buildSection(title: '8. 만 14세 미만 아동의 개인정보 처리'),
            _buildText('REphoto 앱은 만 14세 미만 아동의 개인정보를 별도로 수집하지 않으며, 만 14세 미만 아동이 사용할 경우 법정대리인의 동의를 권장합니다.'),
            
            _buildSection(title: '9. 개인정보처리방침의 변경'),
            _buildText('본 개인정보처리방침이 변경되는 경우, 앱 업데이트를 통해 공지하겠습니다.'),
            
            _buildSection(title: '10. 개인정보보호 책임자'),
            _buildText('개인정보보호 책임자: REphoto 개발팀', isBold: true),
            _buildText('연락처: Google Play 스토어 앱 페이지를 통한 문의', isBold: true),
            
            const SizedBox(height: 24),
            Container(
              height: 1,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            
            _buildText('최종 수정일: 2024년 8월 24일', isBold: true),
            _buildText('버전: 1.0', isBold: true),
            const SizedBox(height: 8),
            _buildText('본 개인정보처리방침은 「개인정보보호법」 등 관련 법령에 따라 작성되었습니다.'),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection({required String title, bool isMain = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isMain ? 24 : 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1976D2),
        ),
      ),
    );
  }
  
  Widget _buildSubSection({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF424242),
        ),
      ),
    );
  }
  
  Widget _buildText(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }
  
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14, color: Colors.black87)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}