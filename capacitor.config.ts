import type { CapacitorConfig } from '@capacitor/cli';

// La app carga la web publicada: lo que se publique en Lovable aparece en la app
// sin pasar por las tiendas. `www/` solo contiene la pantalla «Sin conexión».
const config: CapacitorConfig = {
  appId: 'com.terraveraclub.app',
  appName: 'Club TERRAVERA',
  webDir: 'www',
  backgroundColor: '#02111C',
  appendUserAgent: 'ClubTerraveraApp',
  server: {
    url: 'https://terraveraclub.com',
    cleartext: false,
    allowNavigation: ['terraveraclub.com', '*.supabase.co'],
    errorPath: 'index.html',
  },
  ios: {
    contentInset: 'never',
    backgroundColor: '#02111C',
  },
  android: {
    backgroundColor: '#02111C',
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 1500,
      launchAutoHide: true,
      backgroundColor: '#02111C',
      showSpinner: false,
      androidScaleType: 'CENTER_INSIDE',
    },
    StatusBar: {
      style: 'DARK',
      backgroundColor: '#02111C',
      overlaysWebView: false,
    },
    PushNotifications: {
      presentationOptions: ['badge', 'sound', 'alert'],
    },
  },
};

export default config;
