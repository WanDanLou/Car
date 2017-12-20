#include <Timer.h>
#include "msp430usart.h"
configuration CarC {
  provides{
    interface InterfaceCar;
  }
  uses {
    //CarC要在Car.nc之外要使用的接口
    interface Resource;
  }
}
implementation {
  components new CarP() as APP;
  components new Msp430Uart0C();
  components HplMsp430GeneralIOC as GIO;
  components HplMsp430Usart0C as UsartC; //HplMsp430Usart HplMsp430UsartInterrupts
  InterfaceCar = APP;
  APP.Resource = Msp430Uart0C.Resource;
  APP.ResourceRequested = Msp430Uart0C.ResourceRequested;
  APP.Port20 = GIO.Port20;
  APP.Usart = UsartC.HplMsp430Usart;
  APP.Interrupts = UsartC.HplMsp430UsartInterrupts;
  //
}
