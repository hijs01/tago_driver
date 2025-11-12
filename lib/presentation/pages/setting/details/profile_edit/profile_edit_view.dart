import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:tago_driver/data/models/user.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';
import 'package:tago_driver/presentation/pages/setting/details/profile_edit/profile_edit_view_model.dart';
import 'package:tago_driver/l10n/app_localizations.dart';

/// 프로필 수정 화면
///
/// 기능:
/// 1. 현재 프로필 정보 표시 (이름, 이메일)
/// 2. 프로필 정보 수정
/// 3. 실시간 유효성 검증
/// 4. 변경사항 저장
///
/// 사용 위치:
/// - settings_view.dart의 "프로필 수정" 탭
/// - 프로필 카드의 수정 버튼
class ProfileEditView extends StatefulWidget {
  /// 수정할 유저 정보
  /// settings_view에서 Navigator.push로 전달받음
  final AppUser user;

  const ProfileEditView({super.key, required this.user});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  /// 화면이 생성될 때 호출
  /// ViewModel 초기화 (유저 정보 설정, TextField 초기값 설정)
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileEditViewModel>().initialize(widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileEditViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.editProfile,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          // 저장 버튼 (AppBar 오른쪽)
          TextButton(
            onPressed:
                vm.hasChanges && !vm.isSaving
                    ? () => vm.saveProfile(context)
                    : null, // 변경사항 없거나 저장 중이면 비활성화
            child:
                vm.isSaving
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : Text(
                      l10n.save,
                      style: TextStyle(
                        color:
                            vm.hasChanges ? Colors.blueAccent : Colors.white38,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ],
      ),
      scrollable: true,
      body: _buildEditForm(context, vm, l10n),
    );
  }

  /// 프로필 수정 폼 UI
  ///
  /// 구성:
  /// 1. 프로필 아이콘 (상단 중앙)
  /// 2. 이름 입력 필드
  /// 3. 이메일 입력 필드
  /// 4. 안내 문구
  ///
  /// @param context BuildContext
  /// @param vm ProfileEditViewModel
  /// @param l10n AppLocalizations
  Widget _buildEditForm(BuildContext context, ProfileEditViewModel vm, AppLocalizations l10n) {
    // AppBar 높이를 고려한 여백 추가
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: appBarHeight + statusBarHeight + 20),

        // 프로필 아이콘
        _buildProfileIcon(vm),

        const SizedBox(height: 40),

        // 이름 입력 필드
        _buildNameField(vm, l10n),

        const SizedBox(height: 24),

        // 이메일 입력 필드
        _buildEmailField(vm, l10n),

        const SizedBox(height: 32),

        // 안내 문구
        _buildHelpText(l10n),
      ],
    );
  }

  /// 프로필 아이콘 (상단 중앙)
  ///
  /// 표시:
  /// - 이름의 첫 글자를 대문자로 표시
  /// - 원형 배경에 블루 색상
  ///
  /// @param vm ProfileEditViewModel
  Widget _buildProfileIcon(ProfileEditViewModel vm) {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blueAccent,
        child: Text(
          vm.nameController.text.isNotEmpty
              ? vm.nameController.text[0].toUpperCase()
              : '?',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 이름 입력 필드
  ///
  /// 기능:
  /// 1. 이름 입력받기
  /// 2. 실시간 유효성 검증
  /// 3. 에러 메시지 표시
  /// 4. 입력할 때마다 프로필 아이콘 업데이트
  ///
  /// 유효성 검증:
  /// - 2자 이상이어야 함
  /// - 비어있으면 안 됨
  ///
  /// @param vm ProfileEditViewModel
  /// @param l10n AppLocalizations
  Widget _buildNameField(ProfileEditViewModel vm, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l10n.nameLabel,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // 입력 필드
        TextField(
          controller: vm.nameController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: l10n.nameHint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            prefixIcon: Icon(
              Icons.person_outline,
              color: Colors.white.withOpacity(0.5),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            // 에러 메시지 표시
            errorText:
                vm.nameController.text.isNotEmpty ? vm.validateName() : null,
          ),
          onChanged: (_) {
            // 입력할 때마다 UI 갱신 (아이콘 업데이트, 저장 버튼 활성화)
            vm.notifyListeners();
          },
        ),
      ],
    );
  }

  /// 이메일 입력 필드
  ///
  /// 기능:
  /// 1. 이메일 입력받기
  /// 2. 실시간 유효성 검증
  /// 3. 에러 메시지 표시
  ///
  /// 유효성 검증:
  /// - 이메일 형식이어야 함 (xxx@xxx.xxx)
  /// - 비어있으면 안 됨
  ///
  /// @param vm ProfileEditViewModel
  /// @param l10n AppLocalizations
  Widget _buildEmailField(ProfileEditViewModel vm, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l10n.emailLabel,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // 입력 필드
        TextField(
          controller: vm.emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: l10n.emailHint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Colors.white.withOpacity(0.5),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            // 에러 메시지 표시
            errorText:
                vm.emailController.text.isNotEmpty ? vm.validateEmail() : null,
          ),
          onChanged: (_) {
            // 입력할 때마다 UI 갱신 (저장 버튼 활성화)
            vm.notifyListeners();
          },
        ),
      ],
    );
  }

  /// 안내 문구
  ///
  /// 내용:
  /// - 프로필 정보 용도 설명
  /// - 주의사항
  /// @param l10n AppLocalizations
  Widget _buildHelpText(AppLocalizations l10n) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blueAccent.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.profileInfoMessage,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
