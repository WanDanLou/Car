PortB#include <Timer.h>
#include "msp430usart.h"
module ButtonP {
  provides{
    interface Button;
  }
  uses {
    //CarC要在Car.nc之外要使用的接口
    interface HplMspGeneralIO as PortA;
    interface HplMspGeneralIO as PortB;
    interface HplMspGeneralIO as PortC;
    interface HplMspGeneralIO as PortD;
    interface HplMspGeneralIO as PortE;
    interface HplMspGeneralIO as PortF;
  }
}
implementation{
  command void Button.Start(){
    call PortA.clr();
    call PortA.makeInput();
    call PortB.clr();
    call PortB.makeInput();
    call PortC.clr();
    call PortC.makeInput();
    call PortE.clr();
    call PortE.makeInput();
    call PortD.clr();
    call PortD.makeInput();
    call PortF.clr();
    call PortF.makeInput();
  }
  default event void Button.StartDone(error_t error){}
  command void Button.Stop(){}
  default event void Button.StopDone(error_t error){}
  command void Button.PinValueA(){
    if(call PortA.get()){
      signal Button.PinValueADone(SUCCESS);
    }
    else signal Button.PinValueADone(FAIL);
  }
  default event void Button.PinValueADone(error_t error){}
  command void Button.PinValueB(){
    if(call PortB.get()){
      signal Button.PinValueBDone(SUCCESS);
    }
    else signal Button.PinValueBDone(FAIL);
  }
  default event void Button.PinValueBDone(error_t error){}
  command void Button.PinValueC(){
    if(call PortC.get()){
      signal Button.PinValueCDone(SUCCESS);
    }
    else signal Button.PinValueCDone(FAIL);
  }
  default event void Button.PinValueCDone(error_t error){}
  command void Button.PinValueD(){
    if(call PortD.get()){
      signal Button.PinValueDDone(SUCCESS);
    }
    else signal Button.PinValueDDone(FAIL);
  }
  default event void Button.PinValueDDone(error_t error){}
  command void Button.PinValueE(){
    if(call PortE.get()){
      signal Button.PinValueEDone(SUCCESS);
    }
    else signal Button.PinValueEDone(FAIL);
  }
  default event void Button.PinValueEDone(error_t error){}
  command void Button.PinValueF(){
    if(call PortF.get()){
      signal Button.PinValueFDone(SUCCESS);
    }
    else signal Button.PinValueFDone(FAIL);
  }
  default event void Button.PinValueFDone(error_t error){}
}
