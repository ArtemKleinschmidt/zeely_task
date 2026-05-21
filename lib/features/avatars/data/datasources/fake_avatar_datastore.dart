import '../../../../core/constants/app_assets.dart';
import '../../domain/entities/avatar_flavor.dart';
import '../../domain/entities/avatar_gender.dart';
import '../../domain/entities/avatar_pose.dart';
import '../models/avatar_model.dart';
import 'avatar_datastore.dart';

final class FakeAvatarDatastore implements AvatarDatastore {
  const FakeAvatarDatastore();

  @override
  Future<List<AvatarModel>> getAvatars() async {
    return _avatars;
  }

  static final List<AvatarModel> _avatars = [
    AvatarModel(
      id: 'avatar_001',
      firstName: 'Ethan',
      lastName: 'Carter',
      gender: Gender.male,
      age: 45,
      pose: Pose.standing,
      imagePath: AppAvatarAssets.avatar001Male45Standing,
      flavors: [AvatarFlavor.confident, AvatarFlavor.grounded],
      score: 4.8,
      description:
          'Ethan radiates authority and trust. Works well for finance, professional services, and leadership brands where credibility matters most.',
    ),
    AvatarModel(
      id: 'avatar_002',
      firstName: 'Olivia',
      lastName: 'Bennett',
      gender: Gender.female,
      age: 38,
      pose: Pose.standing,
      imagePath: AppAvatarAssets.avatar002Female38Standing,
      flavors: [
        AvatarFlavor.warm,
        AvatarFlavor.natural,
        AvatarFlavor.confident,
        AvatarFlavor.empathetic,
      ],
      score: 4.9,
      description:
          'A naturally warm face that builds trust instantly. Olivia works well for product reviews, educational content, and wellness brands where emotional connection matters.',
    ),
    AvatarModel(
      id: 'avatar_003',
      firstName: 'Liam',
      lastName: 'Foster',
      gender: Gender.male,
      age: 27,
      pose: Pose.standing,
      imagePath: AppAvatarAssets.avatar003Male27Standing,
      flavors: [AvatarFlavor.playful, AvatarFlavor.natural],
      score: 4.5,
      description:
          'Liam\'s relaxed energy fits lifestyle, tech, and youth-oriented brands looking for an approachable everyday voice.',
    ),
    AvatarModel(
      id: 'avatar_004',
      firstName: 'Emma',
      lastName: 'Collins',
      gender: Gender.female,
      age: 22,
      pose: Pose.standing,
      imagePath: AppAvatarAssets.avatar004Female22Standing,
      flavors: [AvatarFlavor.playful, AvatarFlavor.warm],
      score: 4.3,
      description:
          'Emma brings youthful brightness to fashion, beauty, and social-first campaigns that need authentic Gen-Z appeal.',
    ),
    AvatarModel(
      id: 'avatar_005',
      firstName: 'Noah',
      lastName: 'Parker',
      gender: Gender.male,
      age: 37,
      pose: Pose.sitting,
      imagePath: AppAvatarAssets.avatar005Male37Sitting,
      flavors: [AvatarFlavor.grounded, AvatarFlavor.confident],
      score: 4.6,
      description:
          'Steady and composed, Noah is a natural fit for business, real estate, and consulting services.',
    ),
    AvatarModel(
      id: 'avatar_006',
      firstName: 'Ava',
      lastName: 'Morgan',
      gender: Gender.female,
      age: 18,
      pose: Pose.sitting,
      imagePath: AppAvatarAssets.avatar006Female18Sitting,
      flavors: [AvatarFlavor.playful, AvatarFlavor.natural, AvatarFlavor.warm],
      score: 4.2,
      description:
          'Ava\'s casual and accessible style suits social media content and lifestyle brands targeting younger audiences.',
    ),
    AvatarModel(
      id: 'avatar_007',
      firstName: 'Mason',
      lastName: 'Reed',
      gender: Gender.male,
      age: 30,
      pose: Pose.sitting,
      imagePath: AppAvatarAssets.avatar007Male30Sitting,
      flavors: [AvatarFlavor.natural, AvatarFlavor.grounded],
      score: 4.4,
      description:
          'Mason has an easy, neutral presence that works across categories without drawing attention away from the product.',
    ),
    AvatarModel(
      id: 'avatar_008',
      firstName: 'Sofia',
      lastName: 'Turner',
      gender: Gender.female,
      age: 32,
      pose: Pose.sitting,
      imagePath: AppAvatarAssets.avatar008Female32Sitting,
      flavors: [
        AvatarFlavor.empathetic,
        AvatarFlavor.warm,
        AvatarFlavor.natural,
      ],
      score: 4.7,
      description:
          'Sofia\'s calm demeanor makes her ideal for mental health, healthcare, and parenting content where empathy is key.',
    ),
    AvatarModel(
      id: 'avatar_009',
      firstName: 'Jacob',
      lastName: 'Hayes',
      gender: Gender.male,
      age: 49,
      pose: Pose.selfie,
      imagePath: AppAvatarAssets.avatar009Male49Selfie,
      flavors: [
        AvatarFlavor.confident,
        AvatarFlavor.grounded,
        AvatarFlavor.empathetic,
      ],
      score: 4.6,
      description:
          'Jacob projects dependability and experience. A strong choice for financial planning, insurance, and premium services.',
    ),
    AvatarModel(
      id: 'avatar_010',
      firstName: 'Mia',
      lastName: 'Brooks',
      gender: Gender.female,
      age: 41,
      pose: Pose.selfie,
      imagePath: AppAvatarAssets.avatar010Female41Selfie,
      flavors: [
        AvatarFlavor.warm,
        AvatarFlavor.confident,
        AvatarFlavor.empathetic,
      ],
      score: 4.8,
      description:
          'Mia balances approachability with confidence, making her effective for beauty, wellness, and professional development content.',
    ),
    AvatarModel(
      id: 'avatar_011',
      firstName: 'Lucas',
      lastName: 'Ward',
      gender: Gender.male,
      age: 31,
      pose: Pose.selfie,
      imagePath: AppAvatarAssets.avatar011Male31Selfie,
      flavors: [
        AvatarFlavor.playful,
        AvatarFlavor.confident,
        AvatarFlavor.natural,
      ],
      score: 4.5,
      description:
          'Lucas brings high energy and charisma to tech reviews, gaming, and brand campaigns that want a bold, dynamic voice.',
    ),
    AvatarModel(
      id: 'avatar_012',
      firstName: 'Chloe',
      lastName: 'Price',
      gender: Gender.female,
      age: 19,
      pose: Pose.selfie,
      imagePath: AppAvatarAssets.avatar012Female19Selfie,
      flavors: [AvatarFlavor.playful, AvatarFlavor.warm],
      score: 4.1,
      description:
          'Chloe\'s fresh look connects with teen and young adult audiences across fashion, food, and entertainment.',
    ),
    AvatarModel(
      id: 'avatar_013',
      firstName: 'Daniel',
      lastName: 'Stone',
      gender: Gender.male,
      age: 44,
      pose: Pose.carSelfie,
      imagePath: AppAvatarAssets.avatar013Male44SelfieCar,
      flavors: [AvatarFlavor.confident, AvatarFlavor.grounded],
      score: 4.7,
      description:
          'Daniel\'s executive presence works well for automotive, real estate, and high-ticket service brands.',
    ),
    AvatarModel(
      id: 'avatar_014',
      firstName: 'Grace',
      lastName: 'Palmer',
      gender: Gender.female,
      age: 40,
      pose: Pose.carSelfie,
      imagePath: AppAvatarAssets.avatar014Female40SelfieCar,
      flavors: [
        AvatarFlavor.natural,
        AvatarFlavor.empathetic,
        AvatarFlavor.warm,
      ],
      score: 4.8,
      description:
          'Grace has a sophisticated warmth that resonates in lifestyle, home goods, and professional service advertising.',
    ),
    AvatarModel(
      id: 'avatar_015',
      firstName: 'Owen',
      lastName: 'Mitchell',
      gender: Gender.male,
      age: 25,
      pose: Pose.carSelfie,
      imagePath: AppAvatarAssets.avatar015Male25SelfieCar,
      flavors: [
        AvatarFlavor.playful,
        AvatarFlavor.confident,
        AvatarFlavor.natural,
      ],
      score: 4.4,
      description:
          'Owen\'s youthful confidence plays well in automotive, sports, and adventure lifestyle brands.',
    ),
    AvatarModel(
      id: 'avatar_016',
      firstName: 'Nora',
      lastName: 'Sullivan',
      gender: Gender.female,
      age: 26,
      pose: Pose.carSelfie,
      imagePath: AppAvatarAssets.avatar016Female26SelfieCar,
      flavors: [AvatarFlavor.playful, AvatarFlavor.warm, AvatarFlavor.natural],
      score: 4.3,
      description:
          'Nora\'s spontaneous style suits travel, lifestyle, and social commerce brands with a young female audience.',
    ),
    AvatarModel(
      id: 'avatar_017',
      firstName: 'Henry',
      lastName: 'Coleman',
      gender: Gender.male,
      age: 48,
      pose: Pose.walking,
      imagePath: AppAvatarAssets.avatar017Male48Walking,
      flavors: [
        AvatarFlavor.grounded,
        AvatarFlavor.confident,
        AvatarFlavor.empathetic,
      ],
      score: 4.6,
      description:
          'Henry\'s steady, measured presence works effectively in healthcare, finance, and premium lifestyle sectors.',
    ),
    AvatarModel(
      id: 'avatar_018',
      firstName: 'Ella',
      lastName: 'Hughes',
      gender: Gender.female,
      age: 33,
      pose: Pose.walking,
      imagePath: AppAvatarAssets.avatar018Female33Walking,
      flavors: [AvatarFlavor.natural, AvatarFlavor.warm, AvatarFlavor.playful],
      score: 4.5,
      description:
          'Ella\'s active, upbeat energy makes her a great match for fitness, food, and wellness brands.',
    ),
    AvatarModel(
      id: 'avatar_019',
      firstName: 'Levi',
      lastName: 'Russell',
      gender: Gender.male,
      age: 31,
      pose: Pose.walking,
      imagePath: AppAvatarAssets.avatar019Male31Walking,
      flavors: [
        AvatarFlavor.playful,
        AvatarFlavor.grounded,
        AvatarFlavor.natural,
      ],
      score: 4.4,
      description:
          'Levi\'s dynamic and approachable style suits outdoor, sports, and eco-conscious brands.',
    ),
    AvatarModel(
      id: 'avatar_020',
      firstName: 'Aria',
      lastName: 'Simmons',
      gender: Gender.female,
      age: 27,
      pose: Pose.walking,
      imagePath: AppAvatarAssets.avatar020Female27Walking,
      flavors: [
        AvatarFlavor.warm,
        AvatarFlavor.playful,
        AvatarFlavor.empathetic,
      ],
      score: 4.7,
      description:
          'Aria\'s expressive and personable nature makes her an excellent voice for community-driven brands and storytelling content.',
    ),
  ];
}
