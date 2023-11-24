
class Company {

  final String id;
  final String company;
  final String name;

  Company(this.id, this.company, this.name);

  @override
  String toString() {
    return 'Company{id: $id, company: $company, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Company &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          company == other.company &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ company.hashCode ^ name.hashCode;


}