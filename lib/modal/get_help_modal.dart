import 'package:http/http.dart' as http;

class GetHelpModal {
  String userName;
  String userPhone;
  String userAddress;
  String userMail;
  String helpType;
  String helpDescription;

  GetHelpModal(
      {this.userName,
      this.userPhone,
      this.userAddress,
      this.helpType,
      this.helpDescription,
      this.userMail});

  save() {
    // push this data to web service
    http.post(
      'https://us-central1-aicte-cbeb5.cloudfunctions.net/sendMail?dest=$userMail&name=$userName&phone=$userPhone&helpDescription=$helpDescription&helpType=$helpType&address=$userAddress',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
