import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/feature/onboarding/state/onboarding_provider.dart';
import 'package:experience_app/feature/onboarding/widgets/custom_buttom.dart';
import 'package:go_router/go_router.dart';
import 'package:experience_app/core/navigation/router.dart';

class InterestsView  extends ConsumerWidget{
  const InterestsView({super.key});

  static const List<String> interests = [
    'User Interface',
    'User Experience',
    'User Research',
    'UX Writing',
    'User Testing',
    'Service Design',
    'Strategy',
    'Design Systems'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedInterestsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: 0.5,
                color: Color(0xFF006FFD),
                backgroundColor: Color(0xFFE8E9F1),
                borderRadius: BorderRadius.circular(8),
              ),

              const SizedBox(height: 32),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personalise your\nexperience',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose your interests.',
                  style: TextStyle(
                    color: Color(0XFF71727A)
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Expanded(
                child: ListView.builder(
                  itemCount: interests.length,
                  itemBuilder: (context, index){
                    final item = interests[index];
                    final isSelected = selected.contains(item);

                    return Padding(
                      padding: const EdgeInsets.only(bottom:12),
                      child: GestureDetector(
                        onTap: (){
                          ref
                            .read(selectedInterestsProvider.notifier)
                            .toggleInterest(item);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                              ? const Color(0xFFEAF2FF)
                              : Colors.white,
                            border: Border.all(
                              color: Color(0xFFC5C6CC)
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item),
                              if(isSelected)
                                const Icon(Icons.check, color: Color(0xFF006FFD),),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              CustomButtom(
                text: 'Finish',
                onPressed: () {
                  context.goNamed(Routes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}