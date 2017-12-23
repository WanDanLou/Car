
configuration CarC {
  provides interface Car;
}
implementation {
  components CarP as APP;
  components new Msp430Uart0C() as Msp430Uart0C;
  components HplMsp430GeneralIOC as GIO;
  components HplMsp430Usart0C as UsartC; //HplMsp430Usart HplMsp430UsartInterrupts
  Car = APP;
  APP.Resource -> Msp430Uart0C;
  APP.Port20 -> GIO.Port20;
  APP.Usart -> UsartC;
  APP.Interrupts -> UsartC;
  //
}
