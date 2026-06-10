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

## Platform Notes
- **Flutter web does not support page transition animations** (AnimatedSwitcher, CustomTransitionPage, etc. have no effect or cause jank on web). Skip all animation tasks when targeting `-d chrome`.

## Dev
```bash
flutter run -d chrome   # main build
```
- Hot reload: `r`, hot restart: `R` in terminal
- Auth flow is **active**: app starts at `/splash` (router `initialLocation`), which checks `auth_token` → `/home` if logged in, else `/onboarding` (phone → OTP → terms/profile → success).
- For quick dev testing of a screen, temporarily set `initialLocation` to that route in `lib/core/router/app_router.dart`.

## Changelog (2026-06-02)
- **Bottom nav icons**: light/dark switching working — inactive uses `_light.png`, active uses `_dark.png` via `NavigationBar`
- **Dark mode card colors**: fixed in `app_theme.dart`
- **Services screen**: icon tiles updated to `Image.asset` 48×48
- **Zukkobek avatar**: fixed wrong path (`zukkobek.png` → `assets/images/icons/zukko.png`)
- **bank.png**: replaced with resized 800×450px version (was 1672×941)
