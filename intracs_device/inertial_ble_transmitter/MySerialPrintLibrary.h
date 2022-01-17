#ifndef _MYLIBRARY_H
#define _MYLIBRARY_H
#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif

class MySerialPrintLibrary {
  public:
    //pass a reference to a Print object
    void begin(Serial_* serialPrint);
    void test(char c, float scalar, float x, float y, float z);
  private:
    Serial_* printer;
};
#endif