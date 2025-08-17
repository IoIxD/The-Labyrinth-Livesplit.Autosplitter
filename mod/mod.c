#include <jni.h>
#include <stdint.h>

#ifdef WIN32
#include <windows.h>
BOOL WINAPI DllMainCRTStartup(HINSTANCE const instance, DWORD const reason,
                              LPVOID const reserved) {}
#endif

struct {
  // peculiar/specific values that we can use to hook into stuff in memory
  uint64_t hook1;
  uint64_t hook2;
  uint64_t hook3;
  uint64_t hook4;
  uint64_t hook5;
  // the actual information we want to store
  float x;
  float y;
  float z;
} GLOBAL_INFO;

JNIEXPORT void JNICALL
Java_net_minecraft_src_LabyrinthModNative_init(JNIEnv *env, jobject obj) {
  GLOBAL_INFO.hook1 =
      0b01010101010101010101010101010101010101010101010101010101010101010;
  GLOBAL_INFO.hook2 =
      0b01010101010101010101010101010101010101010101010101010101010101010;
  GLOBAL_INFO.hook3 =
      0b01010101010101010101010101010101010101010101010101010101010101010;
  GLOBAL_INFO.hook4 =
      0b01010101010101010101010101010101010101010101010101010101010101010;
  GLOBAL_INFO.hook5 =
      0b01010101010101010101010101010101010101010101010101010101010101010;

  GLOBAL_INFO.x = 0;
  GLOBAL_INFO.y = 0;
  GLOBAL_INFO.z = 0;
}

JNIEXPORT void JNICALL Java_net_minecraft_src_LabyrinthModNative_setCoords(
    JNIEnv *env, jobject obj, jfloat x, jfloat y, jfloat z) {
  GLOBAL_INFO.x = x;
  GLOBAL_INFO.y = y;
  GLOBAL_INFO.z = z;
}

// obfuscated bindings

JNIEXPORT void JNICALL
Java_om_init(JNIEnv *env, jobject obj) {
  Java_net_minecraft_src_LabyrinthModNative_init(env,obj);
}

JNIEXPORT void JNICALL Java_om_setCoords(
    JNIEnv *env, jobject obj, jfloat x, jfloat y, jfloat z) {
  Java_net_minecraft_src_LabyrinthModNative_setCoords(env,obj,x,y,z);
}
