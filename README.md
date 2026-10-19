# Club TERRAVERA · apps de iPhone y Android

Contenedor nativo (Capacitor 7) que abre **https://terraveraclub.com** y le añade el escáner nativo de QR y las notificaciones push. La app no lleva una copia de la web: lo que se publica en Lovable aparece en la app sin pasar por las tiendas.

Guía completa del proyecto: https://claude.ai/code/artifact/6a4fb7dc-ab64-4f12-b591-eeb50b7f319e

## Qué ya está hecho

| Parte | Estado |
| --- | --- |
| Paso 1 · web en Lovable | Hecho y publicado (19/10/2026) |
| Paso 2 · proyecto Capacitor | Hecho: `capacitor.config.ts`, pantalla «Sin conexión» (`www/`), plugins con las versiones de la guía, carpetas `ios/` y `android/` |
| Paso 3 · iPhone | Hecho en archivos: nombre «TERRAVERA», permiso de cámara, push, Background Modes, Associated Domains (`App.entitlements`), Firebase Messaging, solo iPhone y en vertical, iOS 15+ |
| Paso 4 · Android | Hecho en archivos: nombre «TERRAVERA», cámara, notificaciones, App Links con `autoVerify`, color de las notificaciones, API 36 |
| Paso 5 · iconos | Pendiente del sello en PNG (ver abajo) |

## Pasos en el Mac

Requisitos: Xcode, Android Studio, Node.js LTS y CocoaPods (`brew install cocoapods`).

```sh
git clone <este repositorio> club-terravera-app
cd club-terravera-app
npm install
```

### 1. Sello e iconos

1. Copia el sello de TERRAVERA (oro, fondo transparente, al menos 1024 × 1024 px) en:
   - `assets/logo.png` → icono y pantalla de inicio
   - `www/sello.png` → pantalla «Sin conexión»
2. `npm run assets` genera todos los iconos y pantallas de inicio sobre #02111C.
3. Sustituye `android/app/src/main/res/drawable/ic_stat_terravera.xml` por el sello **en blanco** (el actual es provisional: una «T» en un círculo). En Android Studio: *File → New → Vector Asset* a partir de un SVG del sello.

### 2. Firebase (notificaciones)

1. En [console.firebase.google.com](https://console.firebase.google.com), añade una app iOS y una Android, ambas con `com.terraveraclub.app`.
2. Descarga `GoogleService-Info.plist` → `ios/App/App/` (y añádelo al target App en Xcode).
3. Descarga `google-services.json` → `android/app/`.
4. Sube a Firebase la clave APNs (.p8) del Apple Developer (*Project settings → Cloud Messaging*).
5. En Lovable, añade el secreto `FIREBASE_SERVICE_ACCOUNT` (JSON de la cuenta de servicio).

Sin estos archivos la app arranca y funciona, pero sin notificaciones.

### 3. Sincronizar y abrir

```sh
npm run sync      # copia la configuración e instala los pods de iOS
npm run ios       # abre Xcode
npm run android   # abre Android Studio
```

### 4. iPhone (Xcode)

- *Signing & Capabilities*: elige el equipo de la cuenta de empresa. Las capacidades ya están en `App.entitlements` (Push, Associated Domains) e `Info.plist` (Background Modes).
- Antes de subir a la App Store, cambia `aps-environment` de `development` a `production` en `ios/App/App/App.entitlements` (Xcode lo hace solo al distribuir con perfil de App Store).
- Guarda el TEAM_ID en la web: **Admin → Configuración → Apps móviles**.

### 5. Android (Android Studio)

- Crea la clave de firma una vez (*Build → Generate Signed App Bundle*) y guárdala con su contraseña fuera del repositorio. Activa Play App Signing.
- Guarda las huellas SHA-256 (la de subida y la de Play App Signing) en **Admin → Configuración → Apps móviles**.

### 6. Pruebas en móviles reales

Sigue la lista del Paso 6 de la guía. El simulador de iPhone no tiene cámara ni recibe push. Usa una cuenta de **cliente**: las de administrador y personal no reciben notificaciones.

## Decisiones técnicas

- **Token de Firebase en iPhone.** `@capacitor/push-notifications` entrega en iOS el token de Apple (APNs), pero el servidor envía con Firebase Cloud Messaging. `AppDelegate.swift` lo convierte en token de Firebase con `FirebaseMessaging` antes de pasárselo a la web, que no necesita cambios.
- **API 36 en Android.** Google Play exige apuntar a Android 16 (API 36) para apps nuevas desde el 31/08/2026; Capacitor 7 trae la 35 por defecto. Se ha subido `compileSdk` y `targetSdk` a 36 (`android/variables.gradle`).
- **Solo iPhone.** El target no incluye iPad, así que la App Store no pedirá capturas de iPad.
- **Rutas de los enlaces.** Las mismas que publica la web (`src/lib/app-links.ts`): `/inicio`, `/reset-password`, `/auth*`, `/canje/*`.
- **Sin conexión.** Si terraveraclub.com no carga, Capacitor muestra `www/index.html` (`server.errorPath`); «Reintentar» vuelve a la web.
