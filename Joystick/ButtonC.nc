#include <Timer.h>
#include "msp430usart.h"
generic configuration ButtonC() {
  provides{
    interface Button;
  }
}
implementation {
  components new ButtonP() as APP;
  //components new Msp430Uart0C();
  components HplMsp430GeneralIOC as GIO;
  //components HplMsp430Usart0C as UsartC; //HplMsp430Usart HplMsp430UsartInterrupts
  Button = APP;
  /*APP.Resource = Msp430Uart0C.Resource;
  APP.ResourceRequested = Msp430Uart0C.ResourceRequested;
  APP.Usart = UsartC.HplMsp430Usart;
  APP.Interrupts = UsartC.HplMsp430UsartInterrupts;*/
  APP.PortA -> GIO.Port60;
  APP.PortB -> GIO.Port21;
  APP.PortC -> GIO.Port61;
  APP.PortD -> GIO.Port23;
  APP.PortE -> GIO.Port62;
  APP.PortF -> GIO.Port26;
  //
}
