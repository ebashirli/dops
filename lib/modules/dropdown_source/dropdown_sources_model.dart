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
    return DropdownSourcesModel(
      id: 'list',
      companies: map['companies'][0],
      employeePlaces: map['employeePlaces'][0],
      jobTitles: map['jobTitles'][0],
      levels: map['levels'][0],
      modules: map['modules'][0],
      projects: map['projects'][0] ,
      referenceTypes: map['referenceTypes'][0] ,
      statuses: map['statuses'][0],
      structureTypes: map['structureTypes'][0],
      systemDesignations: map['systemDesignations'][0] ,
    );
  }
}
