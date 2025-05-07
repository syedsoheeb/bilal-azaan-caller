# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Serializable classes and their member fields
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep models used by JSON serialization
-keep class com.bilalazaancaller.app.models.** { *; }

# Keep Android lifecycle classes
-keep class android.arch.lifecycle.** { *; }
-keep class androidx.lifecycle.** { *; }

# Keep JavaScript interface
-keepattributes JavascriptInterface
-keep class * implements android.webkit.JavascriptInterface {
    public *;
}

# Remove debug logs in release build
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
}

# Keep Google Cast API classes if used
-keep class com.google.android.gms.cast.** { *; }

# Keep Amazon Alexa API classes if used
-keep class com.amazon.alexa.** { *; }