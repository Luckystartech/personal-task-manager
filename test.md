## Project Folder Structure
```
lib/
├── core/
│   ├── theme/
│   │   ├── app_base.dart              ← AppBase
│   │   ├── app_theme.dart             ← AppTheme + AppThemeData
│   │   ├── app_responsive_theme.dart
│   │   └── data/
│   │       ├── colors.dart
│   │       ├── typography.dart
│   │       ├── spacing.dart
│   │       └── radius.dart
├── features/
│   └── tasks/
│       ├── data/          ← Hive data source
│       ├── domain/        ← Entities, repositories, use cases
│       └── presentation/  ← Screens, widgets, Riverpod providers
├── shared/
│   ├── widgets/
│   └── utils/
└── main.dart

fvm flutter pub run build_runner build --delete-conflicting-outputs
```