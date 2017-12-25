
module CarP @safe(){
  provides{
    interface Car;
  }
  uses{
    interface Resource;
    interface Leds;
    interface HplMsp430GeneralIO as Port20;
    interface HplMsp430Usart as Usart;
    interface HplMsp430UsartInterrupts as Interrupts;
  }
}
implementation {
  enum{
    // 类型位
    angleType = 1,
    forwardType = 2,
    backType =3,
    leftType = 4,
    rightType = 5,
    pauseType =6,
    angleType2 = 7,
    angleType3 = 8,
  };
  
  uint16_t status;
  uint8_t data[8] = {1,2,0,0,0,255,255,0};

  async event void Interrupts.rxDone(uint8_t t) {}
  async event void Interrupts.txDone() {}

  event void Resource.granted() {
    msp430_uart_union_config_t config = {{ubr: UBR_1MHZ_115200, umctl: UBR_1MHZ_115200, ssel: 0x02, pena: 0, pev: 0, spb: 0,
    clen: 1, listen: 0, mm: 0, ckpl: 0, urxse: 0, urxeie: 0, urxwie: 0, utxe : 1, urxe : 1 }};
    call Usart.setModeUart(&config);
    call Usart.enableUart();
    U0CTL &= ~SYNC;
    while(!(call Usart.isTxEmpty())){}
    call Usart.tx( data[0] );
    while(!(call Usart.isTxEmpty())){}
    call Usart.tx( data[1] );
    while(!(call Usart.isTxEmpty())){}
    call Usart.tx( data[2] );
    while(!(call Usart.isTxEmpty())){}
    call Usart.tx( data[3] );
    while(!(call Usart.isTxEmpty())){}
    call Usart.tx( data[4] );
    while(!(call Usart.isTxEmpty())){}
    call Usart.tx( data[5] );
    while(!(call Usart.isTxEmpty())){}
    call Usart.tx( data[6] );
    while(!(call Usart.isTxEmpty())){}
    call Usart.tx( data[7] );
    
    call Resource.release();
  }
  command error_t Car.Angle(uint16_t value){
    status = angleType;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_t Car.Angle_Senc(uint16_t value){
    status = angleType2;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_t Car.Angle_Third(uint16_t value){
    status = angleType3;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_t Car.Forward(uint16_t value){
    status = forwardType;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_t Car.Back(uint16_t value){
    status = backType;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_t Car.Left(uint16_t value){
    status = leftType;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_t Car.Right(uint16_t value){
    status = rightType;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_t Car.QuiryReader(uint8_t value){

  }
  command error_t Car.Pause(){
    status = pauseType;
    data[2] = status;
    data[3] = 0;
    data[4] = 0;
    return call Resource.request();
  }

  

  command error_t Car.InitMaxSpeed(uint16_t value){}
  command error_t Car.InitMinSpeed(uint16_t value){}
  command error_t Car.InitLeftServo(uint16_t value){}
  command error_t Car.InitRightServo(uint16_t value){}
  command error_t Car.InitMidServo(uint16_t value){}
}

