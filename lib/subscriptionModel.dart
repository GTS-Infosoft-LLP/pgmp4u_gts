List<newButton> permiumbutton = [
  newButton(name: "Monthly", id: 1, amount: "\$250.00"),
  newButton(name: "Quarterly", id: 2, amount: "\$350.00"),
  newButton(name: "Yearly", id: 3, amount: "\$500.00"),
];

class newButton {
  String name;
  int id;
  String amount;
  int type;
  newButton({this.name, this.type = 0, this.id = 0, this.amount = "£25.5"});
}

class subsDuration {}
