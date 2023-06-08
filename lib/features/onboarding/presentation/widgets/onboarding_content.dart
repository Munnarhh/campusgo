class OnboardingContent {
  String image;
  String title;
  String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingContent> contents = [
  OnboardingContent(
      title: 'Book a Seat',
      image: 'assets/images/seat.png',
      description:
          "Purchasing travel ticket(s) is easier\n with the CampusGo app."),
  OnboardingContent(
      title: 'Hire a Vehicle',
      image: 'assets/images/driver.png',
      description:
          "Get a vehicle for individual or group\n use anytime, anywhere at best rates."),
  OnboardingContent(
      title: 'Pick Me Up',
      image: 'assets/images/directions.png',
      description:
          "Cut off the trip to a bus terminal\n when travelling! It is absolutely free."),
  OnboardingContent(
      title: 'Bills Payment',
      image: 'assets/images/wallet.png',
      description:
          "Experience ease while making\n payments for all transactions."),
];
