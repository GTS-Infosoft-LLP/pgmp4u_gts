List<newButton> permiumbutton = [
  newButton(name: "Monthly", id: 1, amount: "£3.99 "),
  newButton(name: "Quarterly", id: 2, amount: "£35.99"),
  newButton(name: "Yearly", id: 3, amount: "£69.99"),
];

class newButton {
  String name;
  int id;
  String amount;
  int type;
  newButton({this.name, this.type = 0, this.id = 0, this.amount = "£25.5"});
}
