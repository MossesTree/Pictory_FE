import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';

/// IA S-1 환경설정에서 진입하는 공통 정적 페이지 뷰어
/// - 공지사항 / 서비스 이용약관 / 개인정보 처리방침 / 문의 안내 등
class StaticDocumentView extends StatelessWidget {
  const StaticDocumentView({
    super.key,
    required this.title,
    required this.sections,
  });

  final String title;
  final List<StaticDocumentSection> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(PicktorySpacing.lg),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: PicktorySpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.heading != null) ...[
                  Text(
                    section.heading!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: PicktorySpacing.sm),
                ],
                Text(
                  section.body,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: Color(0xFF424242),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StaticDocumentSection {
  const StaticDocumentSection({required this.body, this.heading});

  final String? heading;
  final String body;
}
