

class AppEnvironment {
  static const Environments environment = Environments.STAGING;
}

enum Environments { PRODUCTION, STAGING }


   const apiBaseUrlStaging = "https://apivcarestage.vcareprojectmanagement.com/api/v2/";
   const apiBaseUrlProduction = "https://pgmp4uapiconnect.vcareprojectmanagement.com/api/v2/";
 

class AppUrls{
  static String getApiUrl(){
      return AppEnvironment.environment == Environments.STAGING
        ? apiBaseUrlStaging: apiBaseUrlProduction;
   }

  static String getDisscussionRef(){
    return AppEnvironment.environment == Environments.STAGING?  FirebaseConstant.discussionsCollection:FirebaseConstant.live_discussionsCollection;
   }
    static String getUserRef(){
    return AppEnvironment.environment == Environments.STAGING?  FirebaseConstant.usersCollection:FirebaseConstant.live_usersCollection;
   }
       static String getGroupRef(){
    return AppEnvironment.environment == Environments.STAGING?  FirebaseConstant.groupsCollection:FirebaseConstant.live_groupsCollection;
   }
       static String getUserChatRef(){
    return AppEnvironment.environment == Environments.STAGING?  FirebaseConstant.userChatCollection:FirebaseConstant.live_userChatCollection;
   }


}







class FirebaseConstant {
  static String messages = 'messages';

  // root collections
  static String userChatCollection = 'user_chats';
  static String messagesCollection = 'messages';
  static String groupsCollection = 'groups';
  static String usersCollection = 'users';
  static String discussionsCollection = 'discussions';


  static String live_userChatCollection = 'live_user_chats';
  static String live_messagesCollection = 'live_messages';
  static String live_groupsCollection = 'live_groups';
  static String live_usersCollection = 'live_users';
  static String live_discussionsCollection = 'live_discussions';
    static String live_messages = 'live_messages';




}