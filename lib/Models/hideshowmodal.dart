class HideShowResponse{
   int id;
  int is_applicationsupport;
        int is_videoplan;
        int is_flashcard;
        int is_challangequiz;

  HideShowResponse({this.id=0, this.is_applicationsupport=0, this.is_challangequiz=0, this.is_flashcard=0, this.is_videoplan=0});
  HideShowResponse.fromjson(Map<String,dynamic> js){
    print("ttttttttttttttobjtrtttttt ${js}");
  id=js["id"];
is_applicationsupport=js["data"]["is_applicationsupport"];
is_videoplan=js["data"]["is_videoplan"];
is_flashcard=js["data"]["is_flashcard"];
is_challangequiz=js["data"]["is_challangequiz"];

  }
}