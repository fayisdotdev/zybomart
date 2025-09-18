# ZyboMart Flutter App

ZyboMart is a modern e-commerce Flutter application featuring modular
architecture, BLoC state management, and a beautiful UI. This app demonstrates
best practices for scalable Flutter development, including:

- BLoC pattern for all major features (auth, wishlist, product, banner, profile)
- Modular, reusable widgets (ProductGrid, shimmer grids)
- Animated splash screen with logo and branding
- Global font settings using Google Fonts (Poppins)
- Responsive wishlist heart icon with instant UI feedback
- Real-time product search with debounce
- Shimmer loading states for smooth UX

## Features

- User authentication with OTP
- Product listing and search
- Wishlist management
- Banner carousel
- Profile section
- Animated splash screen
- Modular and reusable codebase

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK
- Android Studio or VS Code

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/fayisdotdev/zybomart.git
   cd zybomart
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Add assets:**
   - Place your logo at `assets/images/app_icon.png`.
   - Declare assets in `pubspec.yaml`:
     ```yaml
     flutter:
         assets:
             - assets/images/app_icon.png
     ```
4. **Run the app:**
   ```sh
   flutter run
   ```

## Project Structure

```
lib/
	app.dart                # Main app widget, global theme
	main.dart               # Entry point
	blocs/                  # BLoC files (auth, wishlist, product, banner, profile)
	models/                 # Data models
	pages/                  # Screens (homepage, login, splash, wishlist, profile, etc.)
	repositories/           # API/data logic
	widgets/                # Reusable widgets (ProductGrid, etc.)
assets/
	images/app_icon.png     # App logo
```

## Key Packages

- flutter_bloc
- dio
- flutter_secure_storage
- shimmer
- google_fonts

## Customization

- **Branding:** Replace `assets/images/app_icon.png` with your logo.
- **Colors & Fonts:** Edit `app.dart` for theme customization.
- **API Endpoints:** Update repository files for your backend.

## Contributing

Pull requests are welcome! For major changes, please open an issue first to
discuss what you would like to change.

## License

[MIT](LICENSE)

---

**Developed by [fayisdotdev](https://github.com/fayisdotdev)**
