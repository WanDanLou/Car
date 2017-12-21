#include <Timer.h>
#include "msp430usart.h"
module CarC {
  provides{
    interface Car;
  }
  uses {
    //CarC要在Car.nc之外要使用的接口
  }
}
implementation {
  enum{
    // 类型位
    angleType = 1;
    forwardType = 2;
    backType =3;
    leftType = 4;
    rightType = 5;
    pauseType =6;
    angleType2 = 7;
    angleType3 = 8;
  };
  msp430_uart_union_config_t config = { ubr: UBR_1MHZ_115200, umctl: UBR_1MHZ_115200, ssel: 0x02, pena: 0, pev: 0, spb: 0,
    clen: 1, listen: 0, mm: 0, ckpl: 0, urxse: 0, urxeie: 0, urxwie: 0, utxe : 1, urxe : 1 };
  uint16_t status;
  uint8_t data[9] = {1,2,0,0,0,256,256,0};
  event void Resource.granted() {
    call Usart.setModeUart(config);
    call Usart.enableUart();
    U0CTL &= ~SYNC；
    for(int i = 0; i < 8; i++){
      call Usart.tx( data );
      while(call Usart.isTxEmpty() == FALSE);
    }
    call Resource.release();
  }
  command error_r Car.Angle(uint16_t value){
    status = angleType;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_r Car.Angle_Senc(uint16_t value){
    status = angle2Type;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_r Car.Angle_Third(uint16_t value){
    status = angle3Type;
    data[2] = status;
    data[3] = value/256;
    data[4] = value%256;
    return call Resource.request();
  }
  command error_r Car.Forward(uint16_t value){}
  command error_r Car.Back(uint16_t value){}
  command error_r Car.Left(uint16_t value){}
  command error_r Car.Right(uint16_t value){}
  command error_r Car.QuiryReader(uint8_t value){}
  command error_r Car.Pause(){}
  default event void Car.readDone(error_r state, uint16_t data){}
  command error_r Car.InitMaxSpeed(uint16_t value){}
  command error_r Car.InitMinSpeed(uint16_t value){}
  command error_r Car.InitLeftServo(uint16_t value){}
  command error_r Car.InitRightServo(uint16_t value){}
  command error_r Car.InitMidServo(uint16_t value){}
}
