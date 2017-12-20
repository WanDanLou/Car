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
  command error_r Car.Angle(uint16_t value){}
  command error_r Car.Angle_Senc(uint16_t value){}
  command error_r Car.Angle_Third(uint16_t value){}
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
