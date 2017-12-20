#include <Timer.h>
#include "msp430usart.h"
configuration CarC {
  provides{
    interface InterfaceCar;
  }
  uses {
    //CarC要在Car.nc之外要使用的接口
  }
}
implementation {
  components new CarP() as APP;
  InterfaceCar = APP;
  //
}
