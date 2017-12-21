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
  uses interface Button;
  uses interface Read<uint16_t> as Read1;
  uses interface Read<uint16_t> as Read2;
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
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    counter++;
    if (!busy) {
      BlinkToRadioMsg* btrpkt =
	(BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
      if (btrpkt == NULL) {
	return;
      }
      btrpkt->nodeid = TOS_NODE_ID;
      btrpkt->counter = counter;
      //发送遥感指令
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

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(BlinkToRadioMsg)) {
      BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
      setLeds(btrpkt->counter);
    }
    return msg;
  }

  event void Button.pinvalueADone(error_t err){
    if(err == SUCCESS){
      //发送按键a的命令
    }
  }

  event void Button.pinvalueBDone(error_t err){
    if(err == SUCCESS){
      //发送按键b的命令
    }
  }

  event void Button.pinvalueCDone(error_t err){
    if(err == SUCCESS){
      //发送按键c的命令
    }
  }

  event void Button.pinvalueDDone(error_t err){
    if(err == SUCCESS){
      //发送按键d的命令
    }
  }

  event void Button.pinvalueEDone(error_t err){
    if(err == SUCCESS){
      //发送按键e的命令
    }
  }

  event void Button.pinvalueFDone(error_t err){
    if(err == SUCCESS){
      //发送按键f的命令
    }
  }

  event void Read1.readDone(error_t err, uint16_t value){
    //遥感X输入
  }

  event void Read1.readDone(error_t err, uint16_t value){
    //遥感Y输入
  }
}
