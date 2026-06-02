# G'ozg'on Life

Uzbek super-app for G'ozg'on city.

## Stack
- Flutter (web/mobile), Dart
- Primary color: `#1E3A8A`, Font: Outfit (Google Fonts)
- State: Riverpod, Routing: go_router, Auth: Firebase

## Key Files
- `lib/core/navigation/scaffold_with_nav.dart` — bottom nav shell
- `lib/core/theme/app_theme.dart` — light/dark themes
- `lib/core/navigation/app_router.dart` — all routes

## Bottom Navigation (5 tabs)
| Label | Route | Icon base |
|---|---|---|
| Bosh | /home | home |
| Xizmatlar | /services | more |
| Zukkobek | /zukkobek | zukko |
| Market | /market | market |
| Profil | /profile | profil |

Icons: `assets/images/icons/{name}_light.png` (inactive), `{name}_dark.png` (active), 32×32px.

## Assets
- Banners: `assets/images/*.png`
- Icons: `assets/images/icons/*.png`
- pubspec lists `assets/images/icons/` as a folder entry

## Dev
```bash
flutter run -d chrome   # main build
```
- `/home` route bypasses login for quick dev testing
- Hot reload: `r`, hot restart: `R` in terminal
