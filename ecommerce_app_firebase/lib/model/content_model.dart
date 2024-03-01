class ContentModel {
  String? title, image, description;
  ContentModel({this.title, this.image, this.description});
}

List<ContentModel> content = [
  ContentModel(
    title: "Select from Our\nBest Menu",
    image: "assets/images/screen1.png",
    description: "Pick your food from our menu\nMore than 35 times",
  ),
  ContentModel(
    title: "Easy and Online Payment\nBest Menu",
    image: "assets/images/screen2.png",
    description: "You can pay cash on deleivery and\nCard payment is available",
  ),
  ContentModel(
    title: "Deliver your food at your\nDoorstep",
    image: "assets/images/screen3.png",
    description: "Quick Delivery at Your Doorstep",
  ),
];
