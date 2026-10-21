# Club TERRAVERA · apps de iPhone y Android

Contenedor nativo (Capacitor 7) que abre **https://terraveraclub.com** y le añade el escáner nativo de QR y las notificaciones push. La app no lleva una copia de la web: lo que se publica en Lovable aparece en la app sin pasar por las tiendas.

Guía completa del proyecto: https://claude.ai/code/artifact/6a4fb7dc-ab64-4f12-b591-eeb50b7f319e

## Qué ya está hecho

| Parte | Estado |
| --- | --- |
| Paso 1 · web en Lovable | Hecho y publicado (19/10/2026) |
| Paso 2 · proyecto Capacitor | Hecho: `capacitor.config.ts`, pantalla «Sin conexión» (`www/`), plugins con las versiones de la guía, carpetas `ios/` y `android/` |
| Paso 3 · iPhone | Hecho en archivos: nombre «TERRAVERA», permiso de cámara, push, Background Modes, Associated Domains (`App.entitlements`), Firebase Messaging, solo iPhone y en vertical, iOS 15.5+ (lo exige ML Kit 7) |
| Paso 4 · Android | Hecho en archivos: nombre «TERRAVERA», cámara, notificaciones, App Links con `autoVerify`, color de las notificaciones, API 36, mínimo Android 7.0 (API 24, lo exige la protección automática de Play) |
| Paso 5 · iconos | Hecho con el sello de la web (`public/icon-512.png`): iconos y pantalla de inicio sobre #02111C, e icono de notificación de Android con el monograma |

## Pasos en el Mac

Requisitos: Xcode (seleccionado con `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`), Android Studio, Node.js LTS, CocoaPods y Java 21 (`brew install node@24 cocoapods openjdk@21`).

```sh
git clone <este repositorio> club-terravera-app
cd club-terravera-app
npm install
```

### 1. Sello e iconos

Los iconos ya están generados a partir de `assets/logo.png` (el sello de la web, 512 × 512 px). El icono de 1024 px de la App Store sale ampliado del de 512: si tienes el sello en más resolución, cópialo en `assets/logo.png` y ejecuta `npm run assets`.

El icono de notificación de Android (`android/app/src/main/res/drawable-*/ic_stat_terravera.png`) es el monograma (T y V cruzadas) en blanco sobre transparente, sin el texto circular, que a 24 dp no se lee. Sale del sello de `terravera.svg` (un PNG de 196 px dentro de un SVG de Canva); si algún día hay un vector de verdad, se puede sustituir por un *Vector Asset* en Android Studio.

### 2. Firebase (notificaciones)

1. En [console.firebase.google.com](https://console.firebase.google.com), añade una app iOS y una Android, ambas con `com.terraveraclub.app`.
2. Descarga `GoogleService-Info.plist` → `ios/App/App/`. Ya está añadido al target App en Xcode: si falta el archivo, Xcode no compila.
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

### Simulador de iPhone

Google ML Kit (el lector de QR) solo trae binarios Intel para el simulador, y los simuladores de iOS 26 en un Mac con Apple Silicon ya no los ejecutan («TERRAVERA debe actualizarse»). Para probar en el simulador:

```sh
npm run ios:simulador   # instala los pods sin el lector de QR y abre Xcode
```

El simulador no tiene cámara, así que no se pierde nada. **Antes de compilar para un iPhone real o la App Store, vuelve con `npm run sync`** (reinstala el lector).

### Java 21 para Android

El proyecto usa Gradle 8.11.1 y el Android Gradle Plugin 8.7.2 de Capacitor 7, que **no funcionan con Java 25** (el que trae Android Studio). No actualices el plugin: usa Java 21.

- Android Studio: *Settings → Build, Execution, Deployment → Build Tools → Gradle → Gradle JDK* → `/opt/homebrew/opt/openjdk@21`.
- Línea de comandos: `JAVA_HOME=/opt/homebrew/opt/openjdk@21 ./gradlew assembleDebug` dentro de `android/`.

### 4. iPhone (Xcode)

- *Signing & Capabilities*: elige el equipo de la cuenta de empresa. Las capacidades ya están en `App.entitlements` (Push, Associated Domains) e `Info.plist` (Background Modes).
- Antes de subir a la App Store, cambia `aps-environment` de `development` a `production` en `ios/App/App/App.entitlements` (Xcode lo hace solo al distribuir con perfil de App Store).
- Guarda el TEAM_ID en la web: **Admin → Configuración → Apps móviles**.

### 5. Android (Android Studio)

- La clave de subida ya está creada (alias `upload`) en `~/Documents/TERRAVERA-claves/terravera-upload.jks`, fuera del repositorio. Guarda una copia de seguridad y la contraseña en tu gestor de contraseñas. Activa Play App Signing.
- Para compilar el paquete de Play: `npm run android:aab` (pide la contraseña, no la guarda) → `android/app/build/outputs/bundle/release/app-release.aab`. En cada versión nueva sube `versionCode` y `versionName` en `android/app/build.gradle`.
- Huella SHA-256 de la clave de subida: `A7:20:83:29:D2:FD:0F:B2:C5:AC:F7:DD:14:77:0D:C1:5F:AD:0D:6B:0B:1A:83:89:FC:D8:4E:5B:D3:F7:51:50`.
- Guarda las huellas SHA-256 (la de subida y la de Play App Signing) en **Admin → Configuración → Apps móviles**.

### 6. Pruebas en móviles reales

Sigue la lista del Paso 6 de la guía. El simulador de iPhone no tiene cámara ni recibe push. Usa una cuenta de **cliente**: las de administrador y personal no reciben notificaciones.

## Decisiones técnicas

- **Token de Firebase en iPhone.** `@capacitor/push-notifications` entrega en iOS el token de Apple (APNs), pero el servidor envía con Firebase Cloud Messaging. `AppDelegate.swift` lo convierte en token de Firebase con `FirebaseMessaging` antes de pasárselo a la web, que no necesita cambios.
- **API 36 en Android.** Google Play exige apuntar a Android 16 (API 36) para apps nuevas desde el 31/08/2026; Capacitor 7 trae la 35 por defecto. Se ha subido `compileSdk` y `targetSdk` a 36 (`android/variables.gradle`).
- **Solo iPhone.** El target no incluye iPad, así que la App Store no pedirá capturas de iPad.
- **Rutas de los enlaces.** Las mismas que publica la web (`src/lib/app-links.ts`): `/inicio`, `/reset-password`, `/auth*`, `/canje/*`.
- **Sin conexión.** Si terraveraclub.com no carga, Capacitor muestra `www/index.html` (`server.errorPath`); «Reintentar» vuelve a la web.
