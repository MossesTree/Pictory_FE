import 'package:flutter/material.dart';
import 'package:picktory/views/my/my_theme.dart';

class MyProfileEditSheet extends StatefulWidget {
  const MyProfileEditSheet({
    super.key,
    required this.initialNickname,
    required this.onSave,
  });

  final String initialNickname;
  final Future<bool> Function(String nickname) onSave;

  @override
  State<MyProfileEditSheet> createState() => _MyProfileEditSheetState();
}

class _MyProfileEditSheetState extends State<MyProfileEditSheet> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNickname);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final ok = await widget.onSave(_controller.text);
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
    if (ok) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '프로필 수정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: MyTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: '닉네임',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '2~12자 이내로 입력해주세요',
            style: TextStyle(fontSize: 12, color: MyTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(_isSaving ? '저장 중...' : '저장'),
            ),
          ),
        ],
      ),
    );
  }
}
