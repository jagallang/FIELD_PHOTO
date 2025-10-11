import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppTheme.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      'settings'.tr(),
                      style: const TextStyle(
                        color: AppTheme.white,
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
          padding: const EdgeInsets.all(AppConstants.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppInfoSection(context),
              const SizedBox(height: AppConstants.mediumPadding),
              _buildFeaturesSection(context),
              const SizedBox(height: AppConstants.mediumPadding),
              _buildSupportSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return _buildSectionCard(
      title: 'app_info'.tr(),
      children: [
        _buildListTile(
          icon: Icons.info_outline,
          title: 'Field Photo',
          subtitle: 'Version 1.0',
          onTap: () => _showAboutDialog(context),
        ),
        _buildDivider(),
        _buildListTile(
          icon: Icons.privacy_tip_outlined,
          title: 'privacy_policy'.tr(),
          subtitle: 'privacy_policy_description'.tr(),
          onTap: () => _navigateToPrivacyPolicy(context),
        ),
        _buildDivider(),
        _buildListTile(
          icon: Icons.description_outlined,
          title: '라이센스',
          subtitle: '개인 사용 무료, 기업 사용 문의',
          onTap: () => _navigateToLicense(context),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return _buildSectionCard(
      title: 'features'.tr(),
      children: [
        _buildListTile(
          icon: Icons.language,
          title: 'language_settings'.tr(),
          subtitle: 'korean'.tr(),
          onTap: () => _showLanguageDialog(context),
        ),
        _buildDivider(),
        _buildListTile(
          icon: Icons.photo_size_select_actual,
          title: 'default_quality'.tr(),
          subtitle: 'high_quality'.tr(),
          onTap: () => _showQualityDialog(context),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSectionCard(
      title: 'support'.tr(),
      children: [
        _buildListTile(
          icon: Icons.help_outline,
          title: 'help_center'.tr(),
          subtitle: 'get_help_and_support'.tr(),
          onTap: () => _openHelpCenter(),
        ),
        _buildDivider(),
        _buildListTile(
          icon: Icons.feedback_outlined,
          title: 'send_feedback'.tr(),
          subtitle: 'help_us_improve'.tr(),
          onTap: () => _sendFeedback(context),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.grey800,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            ...children,
          ],
        ),
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
      leading: Icon(icon, color: AppTheme.primaryBlue, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.grey800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.grey600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.grey400,
        size: 20,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.grey200,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Field Photo',
      applicationVersion: '1.0',
      applicationIcon: const Icon(
        Icons.photo_library,
        size: 48,
        color: AppTheme.primaryBlue,
      ),
      children: [
        Text('about_app_description'.tr()),
        const SizedBox(height: 16),
        const Text(
          '© 2025 Field Photo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'episode0611@gmail.com',
          style: TextStyle(color: AppTheme.primaryBlue),
        ),
      ],
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyScreen(),
      ),
    );
  }

  void _navigateToLicense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LicenseScreen(),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('한국어'),
              onTap: () {
                context.setLocale(const Locale('ko'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQualityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_quality'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('high_quality'.tr()),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('medium_quality'.tr()),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('low_quality'.tr()),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _openHelpCenter() {
    // TODO: Implement help center navigation
  }

  void _sendFeedback(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('피드백 보내기'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('개선 사항이나 문의사항을 아래 이메일로 보내주세요:'),
            SizedBox(height: 16),
            Text(
              'episode0611@gmail.com',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
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
      appBar: AppBar(
        title: Text('privacy_policy'.tr()),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Field Photo 개인정보 보호정책',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '최종 업데이트: 2025년 1월',
                style: TextStyle(fontSize: 14, color: AppTheme.grey600),
              ),
              SizedBox(height: 24),

              Text(
                '1. 개인정보 수집',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Field Photo는 사용자의 개인정보를 수집하지 않습니다. 본 애플리케이션은 로컬 환경에서만 작동하며, 사용자의 사진과 데이터는 사용자의 기기에만 저장됩니다.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                '2. 데이터 저장',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• 모든 사진과 레이아웃은 사용자의 로컬 장치에만 저장됩니다.\n'
                '• 외부 서버로 데이터가 전송되지 않습니다.\n'
                '• 사용자가 직접 저장 위치를 지정할 수 있습니다.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                '3. 권한',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '본 애플리케이션은 다음 권한을 필요로 합니다:\n'
                '• 파일 저장 권한: 편집된 사진과 PDF를 저장하기 위함\n'
                '• 사진 접근 권한: 사용자가 선택한 사진을 불러오기 위함',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                '4. 데이터 보안',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Field Photo는 네트워크 연결을 사용하지 않으며, 모든 데이터는 사용자의 기기에서만 처리됩니다. 데이터의 보안은 사용자의 기기 보안 설정에 따라 관리됩니다.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                '5. 문의',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '개인정보 보호정책에 대한 문의사항이 있으시면 아래 이메일로 연락 주시기 바랍니다:\n'
                'episode0611@gmail.com',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 24),

              Text(
                '© 2025 Field Photo. All rights reserved.',
                style: TextStyle(fontSize: 14, color: AppTheme.grey600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('라이센스'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Field Photo 라이센스',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),

              Text(
                '1. 개인 사용 (무료)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.success),
              ),
              SizedBox(height: 8),
              Text(
                'Field Photo는 개인 사용자에게 무료로 제공됩니다. 개인적인 용도로 제한 없이 사용하실 수 있습니다.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                '• 개인 프로젝트\n'
                '• 취미 활동\n'
                '• 교육 목적\n'
                '• 비영리 활동',
                style: TextStyle(fontSize: 16, height: 1.8),
              ),
              SizedBox(height: 24),

              Text(
                '2. 기업/상업적 사용',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
              ),
              SizedBox(height: 8),
              Text(
                '기업 및 상업적 목적으로 사용하시려면 별도 라이센스가 필요합니다.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                '기업 라이센스 문의:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• 이메일: episode0611@gmail.com\n'
                '• 제목: [Field Photo 기업 라이센스 문의]',
                style: TextStyle(fontSize: 16, height: 1.8, color: AppTheme.primaryBlue),
              ),
              SizedBox(height: 12),
              Text(
                '다음 정보를 포함해 주세요:\n'
                '- 회사명 및 사업자 정보\n'
                '- 사용 목적 및 규모\n'
                '- 예상 사용자 수',
                style: TextStyle(fontSize: 16, height: 1.8),
              ),
              SizedBox(height: 24),

              Text(
                '3. 사용 제한',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.error),
              ),
              SizedBox(height: 8),
              Text(
                '• 본 소프트웨어의 재배포 금지\n'
                '• 소스 코드 수정 및 재판매 금지\n'
                '• 리버스 엔지니어링 금지',
                style: TextStyle(fontSize: 16, height: 1.8),
              ),
              SizedBox(height: 24),

              Text(
                '4. 면책 조항',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '본 소프트웨어는 "있는 그대로" 제공되며, 명시적이거나 묵시적인 어떠한 보증도 하지 않습니다. 사용으로 인해 발생하는 모든 위험은 사용자가 부담합니다.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 32),

              Divider(thickness: 2),
              SizedBox(height: 16),

              Text(
                '© 2025 Field Photo. All rights reserved.',
                style: TextStyle(fontSize: 14, color: AppTheme.grey600, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}