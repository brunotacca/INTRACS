#include "MySerialPrintLibrary.h"

void MySerialPrintLibrary::begin(Serial_* serialPrint) {
  printer = serialPrint; //operate on the address of print
  if(printer) {
  printer->begin(115200);
  }     
}

void MySerialPrintLibrary::test(char c, float scalar, float x, float y, float z) {
  if(printer) {
  printer->print(c);
  printer->print(" | ");
  printer->print(scalar);
  printer->print(" | ");
  printer->print(x);
  printer->print(" | ");
  printer->print(y);
  printer->print(" | ");
  printer->println(z);
  }
}
