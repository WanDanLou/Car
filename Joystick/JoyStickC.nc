#include <Msp430Adc12.h>
#include <Timer.h>

generic configuration JoyStickC() {
  provides interface Read<uint16_t> as Read1;
  provides interface Read<uint16_t> as Read2;
}
implementation {
  components new AdcReadClientC() as AdcReadClientC1;
  components new AdcReadClientC() as AdcReadClientC2;
  components JoyStickP;
  Read1 = AdcReadClientC1.Read;
  Read2 = AdcReadClientC2.Read;
  AdcReadClientC1.AdcConfigure -> JoyStickP.AdcConfigure1;
  AdcReadClientC2.AdcConfigure -> JoyStickP.AdcConfigure2;
}
