import 'package:appwrite/appwrite.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('65fa8411e1e7e9088650')
    .setSelfSigned(status: true); // For self signed certificates, only use for development


    Account account =Account(client);

    // creating the user using  email
    Future<String> createUser(String name,String email,String password) async{
    try{
      await account.create(userId :ID.unique(),email:email,password: password);
      return "success";
    } on AppwriteException catch(e){
      return e.message.toString();
    }
    }
    