interface Button
{
  command void Start();
  event void StartDone(error_t error);
  command void Stop();
  event void StopDone(error_t error);
  command void PinValueA();
  event void PinValueADone(error_t error);
  command void PinValueB();
  event void PinValueBDone(error_t error);
  command void PinValueC();
  event void PinValueCDone(error_t error);
  command void PinValueD();
  event void PinValueDDone(error_t error);
  command void PinValueE();
  event void PinValueEDone(error_t error);
  command void PinValueF();
  event void PinValueFDone(error_t error);
}
