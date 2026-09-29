import 'package:flutter/material.dart';

import '../auth/domain/auth_models.dart';
import '../auth/domain/auth_service.dart';
import '../../state/locale_controller.dart';
import '../../widgets/language_selector.dart';
import 'student_profile.dart';

class StudentOnboardingFlow extends StatefulWidget {
  final LocaleController localeController;
  final AuthService authService;
  final AuthProfile signupProfile;
  final String password;

  const StudentOnboardingFlow({
    super.key,
    required this.localeController,
    required this.authService,
    required this.signupProfile,
    required this.password,
  });

  @override
  State<StudentOnboardingFlow> createState() => _StudentOnboardingFlowState();
}

class _StudentOnboardingFlowState extends State<StudentOnboardingFlow> {
  final PageController _page = PageController();
  int _step = 0;
  int _grade = 5;
  final Set<String> _subjects = <String>{};
  final Set<String> _goals = <String>{};
  final Set<String> _hobbies = <String>{};
  double _hours = 2;
  String? _board;
  String _stream = 'Science — PCM';

  List<String> get _gradeSubjects =>
      StudentCurriculum.subjectsFor(_grade, stream: _stream);

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _toggle(Set<String> set, String value) {
    set.contains(value) ? set.remove(value) : set.add(value);
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  void _next() {
    if (_step == 2 && _subjects.isEmpty) {
      return _message('Choose at least one subject.');
    }
    if (_step == 3 && _goals.isEmpty) {
      return _message('Choose at least one career goal.');
    }
    if (_step == 4 && _hobbies.isEmpty) {
      return _message('Pick at least one hobby.');
    }
    if (_step == 6 && _board == null) {
      return _message('Choose your board.');
    }
    if (_step < 7) {
      setState(() => _step++);
      _page.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step--);
    _page.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish() async {
    if (_board == null) {
      return _message('Choose your board.');
    }

    final profile = AuthProfile(
      displayName: widget.signupProfile.displayName,
      identifier: widget.signupProfile.identifier,
      phone: widget.signupProfile.phone,
      details: {
        ...widget.signupProfile.details,
        'class': '$_grade',
        'stage': StudentCurriculum.stageFor(_grade),
        'stream': _grade >= 11 ? _stream : '',
        'subjects': _subjects.join(', '),
        'goals': _goals.join(', '),
        'hobbies': _hobbies.join(', '),
        'studyHours': _hours.toStringAsFixed(1),
        'board': _board!,
      },
    );

    final result = await widget.authService.signUp(
      profile: profile,
      password: widget.password,
      role: UserRole.student,
    );

    if (!mounted) return;
    if (!result.success) {
      return _message('Could not complete your profile. Please try again.');
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => StudentSetupComplete(
          profile: StudentSetupProfile(
            signupProfile: profile,
            classNumber: _grade,
            stage: StudentCurriculum.stageFor(_grade),
            subjects: _subjects.toList(),
            goals: _goals.toList(),
            hobbies: _hobbies.toList(),
            studyHours: _hours,
            board: _board!,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 1000;

            return Stack(
              children: [
                const _Background(),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1250),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: desktop ? 40 : 16,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const _Brand(),
                              const Spacer(),
                              Text(
                                'Step ${_step + 1} of 8',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF667085),
                                ),
                              ),
                              const SizedBox(width: 10),
                              LanguageSelector(
                                controller: widget.localeController,
                                compact: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _Progress(current: _step, total: 8),
                          const SizedBox(height: 12),
                          Expanded(
                            child: PageView(
                              controller: _page,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _AboutStep(profile: widget.signupProfile),
                                _ClassStep(
                                  value: _grade,
                                  onChanged: (value) => setState(() {
                                    _grade = value;
                                    _subjects.clear();
                                  }),
                                ),
                                _SubjectsStep(
                                  grade: _grade,
                                  stream: _stream,
                                  subjects: _subjects,
                                  options: _gradeSubjects,
                                  onStreamChanged: (value) => setState(() {
                                    _stream = value;
                                    _subjects.clear();
                                  }),
                                  onChanged: (value) => setState(
                                    () => _toggle(_subjects, value),
                                  ),
                                ),
                                _GoalsStep(
                                  selected: _goals,
                                  onChanged: (value) => setState(
                                    () => _toggle(_goals, value),
                                  ),
                                ),
                                _HobbiesStep(
                                  selected: _hobbies,
                                  onChanged: (value) => setState(
                                    () => _toggle(_hobbies, value),
                                  ),
                                ),
                                _StudyHoursStep(
                                  hours: _hours,
                                  onChanged: (value) =>
                                      setState(() => _hours = value),
                                ),
                                _BoardStep(
                                  value: _board,
                                  onChanged: (value) =>
                                      setState(() => _board = value),
                                ),
                                _ReadyStep(
                                  profile: widget.signupProfile,
                                  grade: _grade,
                                  board: _board ?? '',
                                  goals: _goals,
                                  hobbies: _hobbies,
                                  hours: _hours,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (_step > 0)
                                OutlinedButton.icon(
                                  onPressed: _back,
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  label: const Text('Back'),
                                ),
                              const Spacer(),
                              FilledButton.icon(
                                onPressed: _step == 7 ? _finish : _next,
                                icon: Icon(
                                  _step == 7
                                      ? Icons.rocket_launch_rounded
                                      : Icons.arrow_forward_rounded,
                                ),
                                label: Text(
                                  _step == 7
                                      ? 'Start My EduVerse'
                                      : 'Continue',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();
  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: Color(0xFF5B55E8)),
          SizedBox(width: 8),
          Text(
            'EduVerse AI',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: Color(0xFF0B2F63),
            ),
          ),
        ],
      );
}

class _Background extends StatelessWidget {
  const _Background();
  @override
  Widget build(BuildContext context) => const Stack(
        children: [
          Positioned(top: -120, right: -80, child: _Orb(size: 300)),
          Positioned(bottom: -130, left: -100, child: _Orb(size: 260)),
        ],
      );
}

class _Orb extends StatelessWidget {
  final double size;
  const _Orb({required this.size});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Color(0xFFDDE5FF), Color(0x00DDE5FF)],
          ),
        ),
      );
}

class _Progress extends StatelessWidget {
  final int current;
  final int total;
  const _Progress({required this.current, required this.total});
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LinearProgressIndicator(
          minHeight: 7,
          value: (current + 1) / total,
        ),
      );
}

class _StepCard extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  const _StepCard({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFF8F7FF)],
              ),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x180B2F63),
                  blurRadius: 34,
                  offset: Offset(0, 18),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -55,
                  top: -55,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0x405B55E8), Color(0x005B55E8)],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFF5B55E8),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x335B55E8),
                                  blurRadius: 16,
                                  offset: Offset(0, 7),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              eyebrow,
                              style: const TextStyle(
                                color: Color(0xFF5146D8),
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.more_horiz_rounded,
                            color: Color(0xFF98A2B3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 32,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0B2F63),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF667085),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      child,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutStep extends StatelessWidget {
  final AuthProfile profile;
  const _AboutStep({required this.profile});

  @override
  Widget build(BuildContext context) {
    final details = <MapEntry<String, String>>[
      MapEntry('Name', profile.displayName),
      MapEntry('Email / ID', profile.identifier),
      if ((profile.phone ?? '').isNotEmpty) MapEntry('Mobile', profile.phone!),
      ...profile.details.entries,
    ];

    return _StepCard(
      eyebrow: 'LET’S GET TO KNOW YOU',
      title: 'Tell us about yourself',
      subtitle:
          'We already have the details you entered during signup. Check them once — you do not need to type them again.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: details
            .map((entry) => _InfoChip(label: entry.key, value: entry.value))
            .toList(),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        width: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE7EAF1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Color(0xFF7B879C),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value.isEmpty ? 'Not provided' : value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF182230),
              ),
            ),
          ],
        ),
      );
}

class _ClassStep extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _ClassStep({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => _StepCard(
        eyebrow: 'YOUR LEARNING LEVEL',
        title: 'Which class are you in?',
        subtitle:
            'EduVerse will adapt lessons, practice, AI help and study plans to your school level.',
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 560;
                final stages = [
                  ('1–5', 'Primary', Icons.menu_book_rounded),
                  ('6–8', 'Middle', Icons.explore_rounded),
                  ('9–10', 'High School', Icons.science_rounded),
                  ('11–12', 'Intermediate', Icons.workspace_premium_rounded),
                ];
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: stages.map((stage) {
                    final active = (stage.$1 == '1–5' && value <= 5) ||
                        (stage.$1 == '6–8' && value >= 6 && value <= 8) ||
                        (stage.$1 == '9–10' && value >= 9 && value <= 10) ||
                        (stage.$1 == '11–12' && value >= 11);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: compact ? (constraints.maxWidth - 10) / 2 : null,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFFEEECFF) : const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: active ? const Color(0xFF7168F4) : const Color(0xFFE7EAF1),
                          width: active ? 1.6 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(stage.$3, size: 20, color: active ? const Color(0xFF5146D8) : const Color(0xFF667085)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stage.$1, style: const TextStyle(fontWeight: FontWeight.w900)),
                              Text(stage.$2, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B55E8), Color(0xFF827AF5)],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                children: [
                  Text(
                    'CLASS $value',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    StudentCurriculum.stageFor(value),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      overlayColor: Colors.white24,
                    ),
                    child: Slider(
                      value: value.toDouble(),
                      min: 1,
                      max: 12,
                      divisions: 11,
                      label: 'Class $value',
                      onChanged: (v) => onChanged(v.round()),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1', style: TextStyle(color: Colors.white70)),
                      Text('6', style: TextStyle(color: Colors.white70)),
                      Text('9', style: TextStyle(color: Colors.white70)),
                      Text('12', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SubjectsStep extends StatelessWidget {
  final int grade;
  final String stream;
  final Set<String> subjects;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onStreamChanged;

  const _SubjectsStep({
    required this.grade,
    required this.stream,
    required this.subjects,
    required this.options,
    required this.onChanged,
    required this.onStreamChanged,
  });

  @override
  Widget build(BuildContext context) => _StepCard(
        eyebrow: 'YOUR SUBJECTS',
        title: 'What do you study?',
        subtitle:
            'These subjects are suggested for Class $grade. Select the subjects that apply to you.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (grade >= 11) ...[
              const Text(
                'Choose your stream',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: StudentCurriculum.streams
                    .map(
                      (item) => ChoiceChip(
                        label: Text(item),
                        selected: stream == item,
                        onSelected: (_) => onStreamChanged(item),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
            ],
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options
                  .map(
                    (option) => FilterChip(
                      label: Text(option),
                      selected: subjects.contains(option),
                      onSelected: (_) => onChanged(option),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
}

class _GoalsStep extends StatelessWidget {
  final Set<String> selected;
  final ValueChanged<String> onChanged;
  const _GoalsStep({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) => _ChoiceStep(
        eyebrow: 'YOUR FUTURE',
        title: 'What would you like to become?',
        subtitle:
            'Pick one or more professions you are curious about. You can change this later.',
        selected: selected,
        options: StudentCurriculum.goals,
        onChanged: onChanged,
      );
}

class _HobbiesStep extends StatelessWidget {
  final Set<String> selected;
  final ValueChanged<String> onChanged;
  const _HobbiesStep({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) => _ChoiceStep(
        eyebrow: 'LIFE OUTSIDE STUDY',
        title: 'What are your hobbies?',
        subtitle:
            'Your hobbies help EduVerse suggest balanced activities and learning projects.',
        selected: selected,
        options: StudentCurriculum.hobbies,
        onChanged: onChanged,
      );
}

class _ChoiceStep extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Set<String> selected;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _ChoiceStep({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => _StepCard(
        eyebrow: eyebrow,
        title: title,
        subtitle: subtitle,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 720 ? 3 : (constraints.maxWidth >= 430 ? 2 : 1);
            final gap = 10.0;
            final width = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: options.map((option) {
                final active = selected.contains(option);
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onChanged(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: width,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFFEEECFF) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: active ? const Color(0xFF6C63EE) : const Color(0xFFE5E7EF),
                        width: active ? 1.7 : 1,
                      ),
                      boxShadow: active
                          ? const [BoxShadow(color: Color(0x145B55E8), blurRadius: 12, offset: Offset(0, 5))]
                          : const [],
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: active ? const Color(0xFF5B55E8) : const Color(0xFFF2F4F7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            active ? Icons.check_rounded : Icons.add_rounded,
                            size: 18,
                            color: active ? Colors.white : const Color(0xFF667085),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                              color: const Color(0xFF182230),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
}

class _StudyHoursStep extends StatelessWidget {
  final double hours;
  final ValueChanged<double> onChanged;
  const _StudyHoursStep({required this.hours, required this.onChanged});

  @override
  Widget build(BuildContext context) => _StepCard(
        eyebrow: 'YOUR ROUTINE',
        title: 'How much time can you study?',
        subtitle:
            'Choose a realistic daily study target. EduVerse will use it to build your plan without overwhelming you.',
        child: Column(
          children: [
            Text(
              '${hours.toStringAsFixed(1)} hours / day',
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Color(0xFF5146D8),
              ),
            ),
            const SizedBox(height: 10),
            Slider(
              value: hours,
              min: 0.5,
              max: 8,
              divisions: 15,
              label: '${hours.toStringAsFixed(1)} h',
              onChanged: onChanged,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('30 min'), Text('4 hours'), Text('8 hours')],
            ),
            const SizedBox(height: 24),
            const Text(
              'Tip: Start with a sustainable target. You can increase it later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF667085)),
            ),
          ],
        ),
      );
}

class _BoardStep extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  const _BoardStep({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => _StepCard(
        eyebrow: 'YOUR CURRICULUM',
        title: 'Which board are you studying under?',
        subtitle:
            'Choose your school board so EduVerse can align your learning path and subject content.',
        child: DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'School Board',
            hintText: 'Choose the curriculum used by your school',
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEECFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.account_balance_rounded, color: Color(0xFF5B55E8)),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          items: StudentCurriculum.boards
              .map(
                (board) => DropdownMenuItem(
                  value: board,
                  child: Text(
                    board,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      );
}

class _ReadyStep extends StatelessWidget {
  final AuthProfile profile;
  final int grade;
  final String board;
  final Set<String> goals;
  final Set<String> hobbies;
  final double hours;

  const _ReadyStep({
    required this.profile,
    required this.grade,
    required this.board,
    required this.goals,
    required this.hobbies,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) => _StepCard(
        eyebrow: 'YOU’RE ALL SET',
        title: 'Your EduVerse journey is ready.',
        subtitle:
            'We’ll use your class, board, subjects, goals, hobbies and study time to personalize your experience.',
        child: Column(
          children: [
            _SummaryRow(
              icon: Icons.school_rounded,
              label: 'Class',
              value: '$grade • ${StudentCurriculum.stageFor(grade)}',
            ),
            _SummaryRow(
              icon: Icons.account_balance_rounded,
              label: 'Board',
              value: board,
            ),
            _SummaryRow(
              icon: Icons.flag_rounded,
              label: 'Goals',
              value: goals.join(', '),
            ),
            _SummaryRow(
              icon: Icons.favorite_rounded,
              label: 'Hobbies',
              value: hobbies.join(', '),
            ),
            _SummaryRow(
              icon: Icons.schedule_rounded,
              label: 'Study target',
              value: '${hours.toStringAsFixed(1)} hours/day',
            ),
            const SizedBox(height: 10),
            const Text(
              'You can edit these preferences anytime from your profile.',
              style: TextStyle(color: Color(0xFF667085)),
            ),
          ],
        ),
      );
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF5B55E8)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(value, style: const TextStyle(color: Color(0xFF667085))),
                ],
              ),
            ),
          ],
        ),
      );
}

class StudentSetupComplete extends StatelessWidget {
  final StudentSetupProfile profile;
  const StudentSetupComplete({super.key, required this.profile});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE9F8EF),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 52,
                      color: Color(0xFF159447),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome to EduVerse!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0B2F63),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${profile.signupProfile.displayName}, your Class ${profile.classNumber} learning space is ready.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF667085),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('Go to EduVerse'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
