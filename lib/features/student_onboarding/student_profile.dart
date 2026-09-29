import '../auth/domain/auth_models.dart';

class StudentSetupProfile {
  final AuthProfile signupProfile;
  final int classNumber;
  final String stage;
  final List<String> subjects;
  final List<String> goals;
  final List<String> hobbies;
  final double studyHours;
  final String board;

  const StudentSetupProfile({
    required this.signupProfile,
    required this.classNumber,
    required this.stage,
    required this.subjects,
    required this.goals,
    required this.hobbies,
    required this.studyHours,
    required this.board,
  });
}

class StudentCurriculum {
  static String stageFor(int grade) {
    if (grade <= 5) return 'Primary School';
    if (grade <= 8) return 'Middle School';
    if (grade <= 10) return 'High School';
    return 'Intermediate';
  }

  static const streams = <String>['Science — PCM', 'Science — PCB', 'Commerce', 'Humanities / Arts', 'Vocational / Other'];

  static List<String> subjectsFor(int grade, {String? stream}) {
    if (grade <= 2) {
      return const ['English', 'Mathematics', 'Environmental Studies', 'Hindi / Regional Language', 'Art & Craft', 'Physical Education'];
    }
    if (grade <= 5) {
      return const ['English', 'Mathematics', 'Environmental Studies', 'Hindi / Regional Language', 'Computer / ICT', 'Art Education', 'Physical Education'];
    }
    if (grade <= 8) {
      return const ['English', 'Mathematics', 'Science', 'Social Science', 'Hindi / Regional Language', 'Computer / ICT', 'Art Education', 'Physical Education'];
    }
    if (grade <= 10) {
      return const ['English', 'Second Language', 'Mathematics', 'Science', 'Social Science', 'Computer / IT / AI', 'Physical Education', 'Art / Skill Subject'];
    }
    switch (stream) {
      case 'Science — PCM':
        return const ['English / Language', 'Physics', 'Chemistry', 'Mathematics', 'Computer Science / Informatics Practices', 'Physical Education', 'Optional Language / Elective'];
      case 'Science — PCB':
        return const ['English / Language', 'Physics', 'Chemistry', 'Biology', 'Psychology / Biotechnology / Computer Science', 'Physical Education', 'Optional Language / Elective'];
      case 'Commerce':
        return const ['English / Language', 'Accountancy', 'Business Studies', 'Economics', 'Mathematics / Applied Mathematics', 'Informatics Practices / Entrepreneurship', 'Physical Education'];
      case 'Humanities / Arts':
        return const ['English / Language', 'History', 'Political Science', 'Geography', 'Economics', 'Psychology / Sociology', 'Fine Arts / Physical Education'];
      default:
        return const ['English / Language', 'Applied / Vocational Subject', 'Mathematics / Applied Mathematics', 'Science / Technical Subject', 'Computer / IT', 'Business / Entrepreneurship', 'Physical Education'];
    }
  }

  static const goals = <String>[
    'Doctor / Healthcare',
    'Engineer / Technology',
    'Scientist / Researcher',
    'Teacher / Professor',
    'Civil Services / Government',
    'Lawyer / Legal Professional',
    'Business / Entrepreneur',
    'Finance / Banking',
    'Designer / Creative Professional',
    'Defence / Armed Forces',
    'Sports Professional',
    'Artist / Performer',
    'Writer / Media',
    'Psychologist / Counsellor',
    'Architect',
    'Environment / Sustainability',
    'Unsure — help me explore',
  ];

  static const hobbies = <String>[
    'Reading', 'Drawing & Painting', 'Music', 'Dance', 'Sports', 'Gaming',
    'Coding', 'Robotics', 'Science Experiments', 'Writing', 'Photography',
    'Cooking', 'Crafts', 'Public Speaking', 'Travel', 'Gardening', 'Chess',
    'Watching Movies', 'Volunteering', 'Other',
  ];

  // National boards and the state/UT school boards represented in the Ministry of Education's school-board listing.
  static const boards = <String>[
    'CBSE — Central Board of Secondary Education',
    'CISCE — ICSE / ISC',
    'NIOS — National Institute of Open Schooling',
    'Andhra Pradesh Board',
    'Arunachal Pradesh Board',
    'Assam State Board',
    'Bihar School Examination Board',
    'Chhattisgarh Board',
    'Goa Board',
    'Gujarat Board',
    'Haryana Board',
    'Himachal Pradesh Board',
    'Jammu & Kashmir Board',
    'Jharkhand Academic Council',
    'Karnataka State Board',
    'Kerala Board',
    'Madhya Pradesh Board',
    'Maharashtra State Board',
    'Manipur Board',
    'Meghalaya Board',
    'Mizoram Board',
    'Nagaland Board',
    'Odisha Board of Secondary Education / CHSE Odisha',
    'Punjab School Education Board',
    'Rajasthan Board',
    'Sikkim Board',
    'Tamil Nadu State Board',
    'Telangana State Board',
    'Tripura Board',
    'Uttar Pradesh Madhyamik Shiksha Parishad',
    'Uttarakhand Board',
    'West Bengal Board',
    'Delhi Government / Directorate of Education Board',
    'Other / International / School-specific',
  ];
}
