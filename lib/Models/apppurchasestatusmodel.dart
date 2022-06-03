class ModelStatus{
  int flashCardStatus=0;
  int videoLibStatus=0;
  ModelStatus.fromjson(Map<String,dynamic> js){
flashCardStatus=js["flashCardStatus"]??0;
videoLibStatus=js["videoLibraryStatus"]??0;

  }
}