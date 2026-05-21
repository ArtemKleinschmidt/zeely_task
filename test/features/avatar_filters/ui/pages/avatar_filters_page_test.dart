import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zeely_task/core/translations/app_translations.dart';
import 'package:zeely_task/core/widgets/app_outlined_frame.dart';
import 'package:zeely_task/features/avatar_filters/domain/entities/avatar_filter_category.dart';
import 'package:zeely_task/features/avatar_filters/domain/usecases/apply_avatar_filters_use_case.dart';
import 'package:zeely_task/features/avatar_filters/presentation/controllers/avatar_filters_controller.dart';
import 'package:zeely_task/features/avatar_filters/ui/pages/avatar_filters_page.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_entity.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_gender.dart';
import 'package:zeely_task/features/avatars/domain/entities/avatar_pose.dart';
import 'package:zeely_task/features/avatars/domain/usecases/get_avatars_use_case.dart';

final class MockGetAvatarsUseCase extends Mock implements GetAvatarsUseCase {}

const _testAvatar = AvatarEntity(
  id: 'test-1',
  firstName: 'Test',
  lastName: 'Avatar',
  imagePath: 'assets/images/avatar_001_male_45_standing.png',
  gender: Gender.male,
  age: 30,
  pose: Pose.standing,
  flavors: [],
  score: 4.5,
  description: 'A test avatar.',
);

void main() {
  late MockGetAvatarsUseCase mockGetAvatarsUseCase;
  late AvatarFiltersController controller;

  setUp(() {
    mockGetAvatarsUseCase = MockGetAvatarsUseCase();
  });

  tearDown(() {
    Get.reset();
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    required Future<List<AvatarEntity>> avatarsResult,
  }) async {
    when(() => mockGetAvatarsUseCase()).thenAnswer((_) => avatarsResult);
    controller = AvatarFiltersController(
      getAvatarsUseCase: mockGetAvatarsUseCase,
      applyAvatarFiltersUseCase: const ApplyAvatarFiltersUseCase(),
    );
    Get.put(controller);
    await tester.pumpWidget(
      GetMaterialApp(
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        home: const AvatarFiltersPage(),
      ),
    );
  }

  group('AvatarFiltersPage — rendering', () {
    testWidgets('shows All avatars heading', (tester) async {
      await pumpPage(
        tester,
        avatarsResult: Completer<List<AvatarEntity>>().future,
      );

      expect(find.text('All avatars'), findsOneWidget);
    });

    testWidgets('shows loading indicator while avatars are being fetched', (
      tester,
    ) async {
      await pumpPage(
        tester,
        avatarsResult: Completer<List<AvatarEntity>>().future,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows filter chips for all three categories', (tester) async {
      await pumpPage(
        tester,
        avatarsResult: Completer<List<AvatarEntity>>().future,
      );

      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Pose'), findsOneWidget);
    });

    testWidgets('does not show reset chip when no filters are active', (
      tester,
    ) async {
      await pumpPage(
        tester,
        avatarsResult: Completer<List<AvatarEntity>>().future,
      );

      // Three category chips → three AppOutlinedFrame widgets
      expect(find.byType(AppOutlinedFrame), findsNWidgets(3));
    });

    testWidgets('shows reset chip when at least one filter is active', (
      tester,
    ) async {
      await pumpPage(tester, avatarsResult: Future.value([_testAvatar]));
      await tester.pumpAndSettle();

      controller.replaceSelection(AvatarFilterCategory.gender, {Gender.male});
      await tester.pumpAndSettle();

      // Reset chip adds a fourth AppOutlinedFrame alongside the three category chips
      expect(find.byType(AppOutlinedFrame), findsNWidgets(4));
    });

    testWidgets('shows error title and retry button when loading fails', (
      tester,
    ) async {
      await pumpPage(
        tester,
        avatarsResult: Future.error(Exception('network error')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('hides loading indicator when avatars are loaded', (
      tester,
    ) async {
      await pumpPage(tester, avatarsResult: Future.value([_testAvatar]));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
      'shows default empty state message when loaded with no avatars and no active filters',
      (tester) async {
        await pumpPage(tester, avatarsResult: Future.value([]));
        await tester.pumpAndSettle();

        expect(find.text('No avatars available yet'), findsOneWidget);
        expect(find.text('Reload avatars'), findsOneWidget);
      },
    );

    testWidgets(
      'shows filtered empty state message when loaded with no results and active filters',
      (tester) async {
        // Load a male avatar, then filter by female so the grid is empty
        await pumpPage(tester, avatarsResult: Future.value([_testAvatar]));
        await tester.pumpAndSettle();

        controller.replaceSelection(AvatarFilterCategory.gender, {
          Gender.female,
        });
        await tester.pumpAndSettle();

        expect(
          find.text('Nothing was found using these filters'),
          findsOneWidget,
        );
        expect(find.text('Clear filters'), findsOneWidget);
      },
    );
  });

  group('AvatarFiltersPage — interactions', () {
    testWidgets('tapping app bar back button asks the platform to close app', (
      tester,
    ) async {
      final platformCalls = <MethodCall>[];

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          platformCalls.add(call);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await pumpPage(
        tester,
        avatarsResult: Completer<List<AvatarEntity>>().future,
      );

      await tester.tap(find.byType(IconButton).first);
      await tester.pump();

      expect(
        platformCalls,
        contains(
          isA<MethodCall>().having(
            (call) => call.method,
            'method',
            'SystemNavigator.pop',
          ),
        ),
      );
    });

    testWidgets('tapping Try again calls loadAvatars a second time', (
      tester,
    ) async {
      await pumpPage(tester, avatarsResult: Future.error(Exception('error')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Try again'));
      await tester.pump();

      // called once from onInit and once from the tap
      verify(() => mockGetAvatarsUseCase()).called(2);
    });

    testWidgets('tapping reset chip calls resetFilters and clears state', (
      tester,
    ) async {
      await pumpPage(tester, avatarsResult: Future.value([_testAvatar]));
      await tester.pumpAndSettle();

      controller.replaceSelection(AvatarFilterCategory.gender, {Gender.male});
      await tester.pumpAndSettle();

      expect(controller.hasActiveFilters, isTrue);

      // The reset chip is the first AppOutlinedFrame (leftmost) in the filter row
      await tester.tap(find.byType(AppOutlinedFrame).first);
      await tester.pumpAndSettle();

      expect(controller.hasActiveFilters, isFalse);
    });

    testWidgets('tapping Reload avatars calls loadAvatars again', (
      tester,
    ) async {
      await pumpPage(tester, avatarsResult: Future.value([]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reload avatars'));
      await tester.pump();

      verify(() => mockGetAvatarsUseCase()).called(2);
    });

    testWidgets('tapping Clear filters resets active filters', (tester) async {
      // Load a male avatar, filter by female to trigger the filtered empty state
      await pumpPage(tester, avatarsResult: Future.value([_testAvatar]));
      await tester.pumpAndSettle();

      controller.replaceSelection(AvatarFilterCategory.gender, {Gender.female});
      await tester.pumpAndSettle();

      expect(find.text('Clear filters'), findsOneWidget);

      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle();

      expect(controller.hasActiveFilters, isFalse);
    });
  });
}
