class UnBoardingContent {
  String image;
  String title;
  String description;

  UnBoardingContent(
      {required this.description, required this.image, required this.title});
}

List<UnBoardingContent> contents = [
  UnBoardingContent(
      description: 'Pick your food from our menu\n More than 35 times ',
      image: 'assets/images/screen1.png',
      title: 'Select the best menu'),
  UnBoardingContent(
      description:
          'You can pay cash on delivery and\n Card payment is available',
      image: 'assets/images/screen2.png',
      title: 'Easy and online payment'),
  UnBoardingContent(
      description: 'Deliver your food at doorstep',
      image: 'assets/images/screen3.png',
      title: 'Quick Delivery Service')
];
