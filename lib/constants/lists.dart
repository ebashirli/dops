// flutter run -d web-server --web-port 8080 --web-hostname 172.30.134.63

List<String> get listNames => [
      'Companies',
      'Employee Places',
      'Job Titles',
      'Levels',
      'Modules',
      'Projects',
      'Reference Types',
      'Statuses',
      'Structure Types',
      'System Designations',
      'Functional Areas',
      'Areas',
    ];

List<String> stageNames = [
  '3D Admin',
  'Designing',
  'Draftering',
  'Checking',
  'Back Drafting',
  'Back Checking',
  'Reviewer',
  'Filing ',
  'Nesting Box',
];

List<Map<String, dynamic>> stageDetailsList = [
  {
    'name': '3D Admin',
    'staff job': '3d Admin',
    'number fields': {
      'suffix': 'Initial quantity',
      'name': [
        'Phase',
        'Weight',
      ],
    },
    'string fields': ['Note'],
  },
  {
    'name': 'Designing',
    'staff job': 'Designers',
    'number fields': {
      'suffix': 'Planned quantity',
      'name': [
        'Weight',
        'GAS',
        'SFD',
        'DTL',
      ],
    },
    'string fields': ['Note'],
  },
  {
    'name': 'Draftering',
    'staff job': 'Drafters',
    'isThereFiles': true,
    'number fields': {
      'suffix': 'Actual quantity',
      'name': [
        'GAS',
        'SFD',
        'DTL',
      ],
    },
    'string fields': ['Note'],
  },
  {
    'name': 'Checking',
    'get files': 'Get whitecopies',
    'staff job': 'Checkers',
    'isThereFiles': true,
    'number fields': [],
    'string fields': ['Note'],
  },
  {
    'name': 'Back Drafting',
    'get files': 'Get checkprints',
    'staff job': 'Back Drafters',
    'isThereFiles': true,
    'number fields': [],
    'string fields': ['Note'],
  },
  {
    'name': 'Back Checking',
    'get files': 'Get checkprints',
    'staff job': 'Back Checkers',
    'isThereFiles': true,
    'number fields': [],
    'string fields': ['Note'],
  },
  {
    'name': 'Reviewing',
    'get files': 'Get checkprints',
    'staff job': 'Reviewers',
    'isThereFiles': true,
    'number fields': [],
    'string fields': ['Note'],
  },
  {
    'name': 'Filing',
    'staff job': 'Filers',
    'number fields': {
      'suffix': 'Actual quantity',
      'name': [
        'Weight',
        'GAS',
        'SFD',
        'DTL',
      ],
    },
    'isThereFiles': true,
    'string fields': ['Note'],
  },
  {
    'name': 'Nesting Box',
    'get files': 'Original Files',
    'staff job': 'Nesting Draftsmen',
    'number fields': [],
    'string fields': ['Note'],
  },
];
