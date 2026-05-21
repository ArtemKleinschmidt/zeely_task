import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:zeely_task/core/translations/app_translations.dart';
import 'package:zeely_task/features/avatar_details/domain/usecases/build_avatar_details_use_case.dart';
import 'package:zeely_task/features/avatar_details/presentation/controllers/avatar_details_controller.dart';
import 'package:zeely_task/features/avatar_details/ui/pages/avatar_details_page.dart';
import 'package:zeely_task/features/avatar_details/ui/widgets/avatar_details_top_bar.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_flavor.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_pose.dart';

const _testAvatar = AvatarEntity(
  id: 'avatar_002',
  firstName: 'Olivia',
  lastName: 'Bennett',
  imagePath: 'assets/images/avatar_002_female_28_standing.png',
  gender: Gender.female,
  age: 28,
  pose: Pose.standing,
  flavors: [AvatarFlavor.warm, AvatarFlavor.natural, AvatarFlavor.confident],
  score: 4.9,
  description: 'A naturally warm face with an empathetic touch.',
);

void main() {
  tearDown(() {
    Get.reset();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    final controller = AvatarDetailsController(
      avatar: _testAvatar,
      buildAvatarDetailsUseCase: const BuildAvatarDetailsUseCaseImpl(),
    );
    Get.put(controller);

    await tester.pumpWidget(
      GetMaterialApp(
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        home: const AvatarDetailsPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('AvatarDetailsPage — rendering', () {
    testWidgets('shows avatar full name', (tester) async {
      await pumpPage(tester);

      expect(find.text('Olivia Bennett'), findsWidgets);
    });

    testWidgets('shows Select avatar button', (tester) async {
      await pumpPage(tester);

      expect(find.text('Select avatar'), findsOneWidget);
    });

    testWidgets('shows flavor chip labels', (tester) async {
      await pumpPage(tester);

      expect(find.text('Warm'), findsOneWidget);
      expect(find.text('Natural'), findsOneWidget);
      expect(find.text('Confident'), findsOneWidget);
    });

    testWidgets('shows About avatar section heading', (tester) async {
      await pumpPage(tester);

      expect(find.text('ABOUT AVATAR'), findsOneWidget);
    });

    testWidgets('shows avatar description', (tester) async {
      await pumpPage(tester);

      expect(
        find.text('A naturally warm face with an empathetic touch.'),
        findsOneWidget,
      );
    });

    testWidgets('shows Example button on the photo card', (tester) async {
      await pumpPage(tester);

      expect(find.text('Example'), findsOneWidget);
    });

    testWidgets('favorite icon starts as favorite_border (unfilled)', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });
  });

  group('AvatarDetailsPage — interactions', () {
    testWidgets('tapping favorite button fills the heart icon', (tester) async {
      await pumpPage(tester);

      await tester.tap(find.byType(FavoriteButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('tapping favorite button twice restores unfilled heart', (
      tester,
    ) async {
      await pumpPage(tester);

      await tester.tap(find.byType(FavoriteButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FavoriteButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('tapping back button pops the route', (tester) async {
      bool popped = false;
      Get.testMode = true;

      final controller = AvatarDetailsController(
        avatar: _testAvatar,
        buildAvatarDetailsUseCase: const BuildAvatarDetailsUseCaseImpl(),
      );
      Get.put(controller);

      await tester.pumpWidget(
        GetMaterialApp(
          translations: AppTranslations(),
          locale: const Locale('en', 'US'),
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                popped = false;
                Get.to<void>(
                  () => const AvatarDetailsPage(),
                  transition: Transition.noTransition,
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(AvatarDetailsPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(AvatarDetailsPage), findsNothing);
      popped = true;
      expect(popped, isTrue);
    });
  });
}
