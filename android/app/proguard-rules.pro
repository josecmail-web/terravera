# Reglas de R8 para la compilación release (minifyEnabled true en build.gradle).
# Capacitor y los plugins ya traen reglas propias (consumerProguardFiles), pero el
# puente JS ⇄ nativo carga los plugins por nombre (assets/capacitor.plugins.json)
# y llama a sus métodos por reflexión: se conservan enteros por si acaso.

# Números de línea en los informes de fallos de Play Console (con el mapping.txt
# que va dentro del .aab), sin exponer el nombre de los archivos fuente.
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod,Exceptions

# Capacitor: puente, WebView y anotaciones de los plugins
-keep class com.getcapacitor.** { *; }
-keep interface com.getcapacitor.** { *; }
-keep @com.getcapacitor.annotation.CapacitorPlugin public class * { *; }
-keep public class * extends com.getcapacitor.Plugin { *; }
-keepclassmembers class * {
    @com.getcapacitor.PluginMethod public <methods>;
    @com.getcapacitor.annotation.PermissionCallback <methods>;
    @com.getcapacitor.annotation.ActivityCallback <methods>;
}
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Actividad principal (la declara el manifiesto, pero la dejamos explícita)
-keep class com.terraveraclub.app.** { *; }

# Plugins oficiales de Capacitor: app, browser, push-notifications, splash-screen, status-bar
-keep class com.capacitorjs.plugins.** { *; }

# @capacitor/push-notifications + Firebase Cloud Messaging
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.iid.** { *; }
-dontwarn com.google.firebase.**

# @capacitor-mlkit/barcode-scanning (ML Kit + CameraX)
-keep class io.capawesome.capacitorjs.plugins.mlkit.barcodescanning.** { *; }
-keep class com.google.mlkit.vision.barcode.** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**
