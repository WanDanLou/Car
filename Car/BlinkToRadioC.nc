#include <Timer.h>
#include "BlinkToRadio.h"

module BlinkToRadioC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Car;
}
implementation {

  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;

  void setLeds(uint16_t val) {
    if (val & 0x01)
      call Leds.led0On();
    else
      call Leds.led0Off();
    if (val & 0x02)
      call Leds.led1On();
    else
      call Leds.led1Off();
    if (val & 0x04)
      call Leds.led2On();
    else
      call Leds.led2Off();
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(1000);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    int type = 0;
    counter++;
    if (!busy) {
      BlinkToRadioMsg* btrpkt =
	(BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
      if (btrpkt == NULL) {
	return;
      }
      type = counter%4;
      type += 2;
      btrpkt->type = type;
      btrpkt->data = 500;
      call Leds.led0Toggle();
      if (call AMSend.send(AM_BROADCAST_ADDR,
          &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  event void Car.readDone(error_t state, uint16_t data){}

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(BlinkToRadioMsg)) {
      BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
      
      //然后拿出对应的数据，决定call接口Car中对应的小车命令
      switch(btrpkt->type){
        case 1:
        call Car.Angle(btrpkt->data);
        break;
        case 2:
        call Car.Forward(btrpkt->data);
        call Leds.led1Toggle();
        break;
        case 3:
        call Car.Back(btrpkt->data);
        call Leds.led1Toggle();
        break;
        case 4:
        call Car.Left(btrpkt->data);
        call Leds.led1Toggle();
        break;
        case 5:
        call Car.Right(btrpkt->data);
        break;
        case 6:
        call Car.Pause();
        break;
        case 7:
        call Car.Angle_Senc(btrpkt->data);
        break;
        case 8:
        call Car.Angle_Third(btrpkt->data);
        break;
        default:
      }
    }
    return msg;
  }
}
