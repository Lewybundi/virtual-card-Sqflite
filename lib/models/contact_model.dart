const String tableContact = 'tbl_contact';
const String tblContactColId = 'id';
const String tblContactColName = 'name';
const String tblContactColMobile = 'mobile';
const String tblContactColEmail = 'email';
const String tblContactColAddress = 'address';
const String tblContactColCompany = 'company';
const String tblContactColDesgnation = 'desgnation';
const String tblContactColWebsite = 'website';
const String tblContactColImage = 'image';
const String tblContactColFavorite = 'favorite';

class ContactModel {
  int id;
  String name;
  String mobile;
  String email;
  String address;
  String company;
  String desgnation;
  String website;
  String image;
  bool favorite;

  ContactModel({
    this.id = -1,
    required this.name,
    required this.mobile,
    this.email = '',
    this.address = '',
    this.company = '',
    this.desgnation = '',
    this.website = '',
    this.image = '',
    this.favorite = false,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      tblContactColName: name,
      tblContactColMobile: mobile,
      tblContactColEmail: email,
      tblContactColImage: image,
      tblContactColDesgnation: desgnation,
      tblContactColAddress: address,
      tblContactColWebsite: website,
      tblContactColFavorite: favorite ? 1 : 0,
      tblContactColCompany: company,
    };
    if (id > 0) {
      map[tblContactColId] = id;
    }
    return map;
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
        id: map[tblContactColId] ?? -1,
        name: map[tblContactColName] ?? '',
        mobile: map[tblContactColMobile] ?? '',
        email: map[tblContactColEmail] ?? '',
        address: map[tblContactColAddress] ?? '',
        desgnation: map[tblContactColDesgnation] ?? '',
        website: map[tblContactColWebsite] ?? '',
        company: map[tblContactColCompany] ?? '',
        image: map[tblContactColImage] ?? '',
        favorite: map[tblContactColFavorite] == 1?true:false,
      );
}
