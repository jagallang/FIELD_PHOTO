import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'presentation/bloc/photo_editor_bloc.dart';
import 'presentation/screens/editor/photo_editor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const PhotoLayoutApp(),
    ),
  );
}

class PhotoLayoutApp extends StatelessWidget {
  const PhotoLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POL PHOTO',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: ChangeNotifierProvider(
        create: (_) => di.sl<PhotoEditorBloc>(),
        child: const PhotoEditorScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}