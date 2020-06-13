class GetHelpModal {
  String userName;
  String userPhone;
  String userAddress;
  String helpType;
  String helpDescription;

  GetHelpModal(
      {this.userName,
      this.userPhone,
      this.userAddress,
      this.helpType,
      this.helpDescription});

  save() {
    // push this data to web service
    print("$userName $userPhone $userAddress $helpType $helpDescription");
  }
}
