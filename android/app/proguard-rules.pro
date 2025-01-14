# Keep BouncyCastle provider classes
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# Keep gRPC-related classes
-keep class io.grpc.** { *; }
-dontwarn io.grpc.**

# Keep classes referenced via reflection
-keepattributes *Annotation*
-keepclassmembers class * {
    @** *;
}
