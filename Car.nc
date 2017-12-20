interface Car
{
  //command void Start();
  command error_r Angle(uint16_t value);
  command error_r Angle_Senc(uint16_t value);
  command error_r Angle_Third(uint16_t value);
  command error_r Forward(uint16_t value);
  command error_r Back(uint16_t value);
  command error_r Left(uint16_t value);
  command error_r Right(uint16_t value);
  command error_r QuiryReader(uint8_t value);
  command error_r Pause();
  event void readDone(error_r state, uint16_t data);
  command error_r InitMaxSpeed(uint16_t value);
  command error_r InitMinSpeed(uint16_t value);
  command error_r InitLeftServo(uint16_t value);
  command error_r InitRightServo(uint16_t value);
  command error_r InitMidServo(uint16_t value);
}
