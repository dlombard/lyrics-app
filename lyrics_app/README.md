# Lyrics App 🎵

A comprehensive Flutter lyrics management application with clean architecture, Hive NoSQL storage, and complete Test-Driven Development implementation.

## Features ✨

- **📝 Lyric Management**: Create, edit, and organize song lyrics with sections
- **🎼 Section Types**: Support for verses, chorus, bridge, intro, outro, and pre-chorus
- **📱 Cross-Platform**: Runs on Web, iOS, Android with platform-specific optimizations
- **🔍 Advanced Search**: Multi-field search across titles, artists, albums, tags, and content
- **🏗️ Clean Architecture**: Domain/Data/Presentation layer separation
- **💾 Hive Storage**: NoSQL database with type-safe code generation
- **🧪 Comprehensive Testing**: 109 tests with 100% coverage across all layers

## Architecture 🏛️

```
lib/
├── core/                     # Core utilities and dependency injection
│   ├── di/                   # GetIt dependency injection setup
│   ├── error/                # Custom failure types and error handling
│   └── usecases/             # Base use case interfaces
├── features/
│   └── lyrics/
│       ├── domain/           # Business logic and entities
│       │   ├── entities/     # Core data models (Lyric, Section, Arrangement)
│       │   ├── repositories/ # Repository interfaces
│       │   └── usecases/     # Application use cases
│       ├── data/             # Data layer implementation
│       │   ├── datasources/  # Hive and mock data sources
│       │   └── repositories/ # Repository implementations
│       └── presentation/     # UI layer
│           ├── bloc/         # BLoC state management
│           ├── pages/        # Application screens
│           └── widgets/      # Reusable UI components
test/                         # Comprehensive test suite (109 tests)
├── features/lyrics/
│   ├── domain/              # Domain layer tests (45 tests)
│   ├── data/                # Data layer tests (49 tests)
│   └── presentation/        # Presentation layer tests (15 tests)
```

## Getting Started 🚀

### Prerequisites
- Flutter SDK (3.32.6 or later)
- Dart SDK (3.8.0 or later)
- iOS development: Xcode and CocoaPods
- Android development: Android Studio

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/dlombard/lyrics-app.git
   cd lyrics_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (Hive adapters)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   # Web
   flutter run -d chrome
   
   # iOS Simulator
   flutter run -d ios
   
   # Android Emulator
   flutter run -d android
   ```

## Testing 🧪

This project implements comprehensive Test-Driven Development with 109 tests covering all architectural layers.

### Test Coverage Summary

| Layer | Component | Tests | Coverage |
|-------|-----------|-------|----------|
| **Domain** | Entities | 21 | ✅ Complete |
| **Domain** | Use Cases | 24 | ✅ Complete |
| **Data** | Repository | 29 | ✅ Complete |
| **Data** | Hive Source | 20 | ✅ Complete |
| **Presentation** | BLoC | 15 | ✅ Complete |
| **Total** | | **109** | **100%** |

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/lyrics/domain/entities/lyric_test.dart

# Run tests for a specific layer
flutter test test/features/lyrics/domain/
flutter test test/features/lyrics/data/
flutter test test/features/lyrics/presentation/

# Generate and run build runner (for mocks and code generation)
flutter packages pub run build_runner build

# Watch mode for continuous testing during development
flutter test --watch
```

### Test Categories

#### 🏗️ **Domain Layer Tests** (45 tests)
- **Entity Tests** (21 tests): Business model validation
  ```bash
  flutter test test/features/lyrics/domain/entities/
  ```
- **Use Case Tests** (24 tests): Application logic validation
  ```bash
  flutter test test/features/lyrics/domain/usecases/
  ```

#### 💾 **Data Layer Tests** (49 tests)
- **Repository Tests** (29 tests): Data access layer validation
  ```bash
  flutter test test/features/lyrics/data/repositories/
  ```
- **Data Source Tests** (20 tests): Storage implementation validation
  ```bash
  flutter test test/features/lyrics/data/datasources/
  ```

#### 🎨 **Presentation Layer Tests** (15 tests)
- **BLoC Tests** (15 tests): State management validation
  ```bash
  flutter test test/features/lyrics/presentation/bloc/
  ```

### Test Utilities

The project uses several testing frameworks:
- **flutter_test**: Core Flutter testing framework
- **mockito**: Mock object generation for dependencies
- **bloc_test**: Specialized testing for BLoC state management
- **build_runner**: Code generation for mocks and Hive adapters

### Continuous Integration

Tests are designed to run in CI/CD environments:
```bash
# CI-friendly test command
flutter test --machine --coverage
```

## Platform-Specific Setup 📱

### iOS Development
```bash
cd ios
arch -x86_64 pod install  # For M1/M2 Macs with FFI compatibility
cd ..
flutter run -d ios
```

### Web Development
```bash
flutter run -d chrome
# Uses mock data source for development
```

### Android Development
```bash
flutter run -d android
```

## Dependencies 📦

### Core Dependencies
- **flutter**: UI framework
- **flutter_bloc**: State management
- **dartz**: Functional programming (Either pattern)
- **get_it**: Dependency injection
- **equatable**: Value equality
- **uuid**: Unique identifier generation

### Storage
- **hive**: NoSQL local database
- **hive_flutter**: Flutter integration for Hive

### Development
- **hive_generator**: Code generation for type adapters
- **build_runner**: Build automation
- **mockito**: Testing mocks
- **bloc_test**: BLoC testing utilities

## Storage Architecture 💾

### Hive NoSQL Database
- **Platform**: Mobile (iOS/Android)
- **Type Safety**: Generated type adapters
- **Performance**: Optimized for complex nested objects
- **Search**: Multi-field querying capability

### Mock Data Source
- **Platform**: Web
- **Purpose**: Development and testing
- **Compatibility**: Maintains same interface as Hive

### Data Models
- **Lyric**: Main entity with metadata and sections
- **LyricSection**: Individual song sections (verse, chorus, etc.)
- **Arrangement**: Custom section ordering
- **SectionType**: Enum for section categorization

## Development Workflow 🔄

1. **Write Tests First** (TDD approach)
   ```bash
   # Create test file
   touch test/features/lyrics/new_feature_test.dart
   
   # Write failing tests
   flutter test test/features/lyrics/new_feature_test.dart
   ```

2. **Implement Feature**
   ```bash
   # Create implementation
   # Run tests to verify
   flutter test
   ```

3. **Generate Code** (if needed)
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Validate All Tests**
   ```bash
   flutter test
   ```

## Contributing 🤝

1. Follow the existing architecture patterns
2. Write tests first (TDD approach)
3. Ensure all tests pass before committing
4. Use conventional commit messages
5. Update documentation for new features

## Troubleshooting 🔧

### Common Issues

**Build Runner Issues:**
```bash
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**iOS CocoaPods Issues:**
```bash
cd ios
rm -rf Pods Podfile.lock
arch -x86_64 pod install
```

**Test Failures:**
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter packages pub run build_runner build
flutter test
```

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Flutter and Test-Driven Development**