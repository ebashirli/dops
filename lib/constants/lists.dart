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

Map<String, List<String>> stageInputFieldListsMap = {
  '3D Admin': ['Phase', 'Initial weight'],
  'Designing': [
    'Designers',
    'Planned Weight',
    'Planned GAS qty',
    'Planned SFD qty',
    'Planned DTL qty',
  ],
  'Draftering': ['Files', 'Actual GAS qty', 'Actual SFD qty', 'Actual DTL qty'],
  'Checking': ['Files'],
  'Back Drafting': ['Files'],
  'Back Checking': ['Comment'],
  'Reviewer': ['Comment'],
  'Filing': [
    'Actual Weight',
    'Actual GAS qty',
    'Actual SFD qty',
    'Actual DTL qty',
    'Files',
  ],
  'Nesting Box': ['Nesting Files']
  
};
