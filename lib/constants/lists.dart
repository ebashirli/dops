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

List<Map<String, dynamic>> stageDetailsList = [
  {
    'name': '3D Admin',
    'staff job': '3d Admin',
    'number fields': [
      'Phase',
      'Initial weight',
    ],
    'string fields': ['Note'],
  },
  {
    'name': 'Designing',
    'staff job': 'Designers',
    'number fields': [
      'Planned Weight',
      'Planned GAS qty',
      'Planned SFD qty',
      'Planned DTL qty',
    ],
    'string fields': ['Note'],
  },
  {
    'name': 'Draftering',
    'staff job': 'Drafters',
    'isThereFiles': true,
    'number fields': [
      'Actual GAS qty',
      'Actual SFD qty',
      'Actual DTL qty',
    ],
    'string fields': ['Note'],
  },
  {
    'name': 'Checking',
    'staff job': 'Checkers',
    'isThereFiles': true,
    'number fields': [],
    'string fields': ['Note'],
  },
  {
    'name': 'Back Drafting',
    'staff job': 'Back Drafters',
    'isThereFiles': true,
    'number fields': [],
    'string fields': ['Note'],
  },
  {
    'name': 'Back Checking',
    'staff job': 'Back Checkers',
    'isThereFiles': true,
    'number fields': [],
    'string fields': ['Note'],
  },
  {
    'name': 'Reviewing',
    'staff job': 'Reviewers',
    'isThereFiles': true,
    'number fields': [],
    'string fields': ['Note'],
  },
  {
    'name': 'Filing',
    'staff job': 'Filers',
    'number fields': [
      'Actual Weight',
      'Actual GAS qty',
      'Actual SFD qty',
      'Actual DTL qty',
    ],
    'isThereFiles': true,
    'string fields': ['Note'],
  },
  {
    'name': 'Nesting Box',
    'staff job': 'Nesting Draftsmen',
    'number fields': [],
    'string fields': [],
  },
];
