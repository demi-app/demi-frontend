import 'package:animated_introduction/animated_introduction.dart';
import '../pages/resources/vectors.dart';

final List<SingleIntroScreen> pages = [
  const SingleIntroScreen(
    title: 'The Entreprenuer',
    description: 'Pursue a new career',
    imageAsset: Vectors.entreprenuerIcon,
  ),
  const SingleIntroScreen(
    title: 'The Artist',
    description: 'Develop your artisic side',
    imageAsset: Vectors.artistIcon,
  ),
  const SingleIntroScreen(
    title: 'The Athlete',
    description: 'Meet your physical goals',
    imageAsset: Vectors.athleteIcon,
  ),
  const SingleIntroScreen(
    title: 'The Student',
    description: 'Learn something new',
    imageAsset: Vectors.learnerIcon,
  ),
];
