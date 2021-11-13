class DropdownSourcesModel {
  String id;
  List<String>? companies;
  List<String>? employeePlaces;
  List<String>? jobTitles;
  List<String>? levels;
  List<String>? modules;
  List<String>? projects;
  List<String>? referenceTypes;
  List<String>? statuses;
  List<String>? structureTypes;
  List<String>? systemDesignations;
  DropdownSourcesModel({
    this.id = 'list',
    this.companies,
    this.employeePlaces,
    this.jobTitles,
    this.levels,
    this.modules,
    this.projects,
    this.referenceTypes,
    this.statuses,
    this.structureTypes,
    this.systemDesignations,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'docId': id,
      'companies': companies,
      'employeePlaces': employeePlaces,
      'jobTitles': jobTitles,
      'levels': levels,
      'modules': modules,
      'projects': projects,
      'referenceTypes': referenceTypes,
      'statuses': statuses,
      'structureTypes': structureTypes,
      'systemDesignations': systemDesignations,
    };
  }

  factory DropdownSourcesModel.fromMap(Map<String, dynamic> map) {
    print("map");
    print("map:$map");
    return DropdownSourcesModel(
      id: 'list',
      companies: map['companies'],
      employeePlaces: map['employeePlaces'],
      jobTitles: map['jobTitles'],
      levels: map['levels'],
      modules: map['modules'],
      projects: map['projects'] ,
      referenceTypes: map['referenceTypes'] ,
      statuses: map['statuses'],
      structureTypes: map['structureTypes'],
      systemDesignations: map['systemDesignations'] ,
    );
  }
}
