-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}

# Jisti Meet SDK

-keep class org.jitsi.meet.** { *; }
-keep class org.jitsi.meet.sdk.** { *; }