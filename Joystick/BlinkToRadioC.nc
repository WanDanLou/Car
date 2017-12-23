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
  uint16_t joyStickX;
  uint16_t joyStickY;
  message_t pkt;
  message_t pkt2;
  bool busy = FALSE;
  bool readX = FALSE;
  bool readY = FALSE;
  enum{
    // 类型位
    angleType = 1,
    forwardType = 2,
    backType = 3,
    leftType = 4,
    rightType = 5,
    pauseType =6,
    angleType2 = 7,
    angleType3 = 8
  };

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
    call Button.PinValueA();
    call Button.PinValueB();
    call Button.PinValueC();
    //call Button.PinValueD();
    call Button.PinValueE();
    call Button.PinValueF();
    call Read1.read();
    call Read2.read();
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
      if (!busy) {
        ControlMsg* btrpkt =
    (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
        if (btrpkt == NULL) {
    return;
        }
        btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType;
        btrpkt->op = 1;
        btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
        if (call AMSend.send(AM_BROADCAST_ADDR,
            &pkt, sizeof(ControlMsg)) == SUCCESS) {
          busy = TRUE;
        }
      }
    }
  }

  event void Button.pinvalueBDone(error_t err){
    if(err == SUCCESS){
      //发送按键b的命令
      if (!busy) {
        ControlMsg* btrpkt =
    (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
        if (btrpkt == NULL) {
    return;
        }
        btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType;
        btrpkt->op = 0;
        btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
        if (call AMSend.send(AM_BROADCAST_ADDR,
            &pkt, sizeof(ControlMsg)) == SUCCESS) {
          busy = TRUE;
        }
      }
    }
  }

  event void Button.pinvalueCDone(error_t err){
    if(err == SUCCESS){
      //发送按键c的命令
      if (!busy) {
        ControlMsg* btrpkt =
    (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
        if (btrpkt == NULL) {
    return;
        }
        btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType2;
        btrpkt->op = 1;
        btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
        if (call AMSend.send(AM_BROADCAST_ADDR,
            &pkt, sizeof(ControlMsg)) == SUCCESS) {
          busy = TRUE;
        }
      }
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
      if (!busy) {
        ControlMsg* btrpkt =
    (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
        if (btrpkt == NULL) {
    return;
        }
        btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType2;
        btrpkt->op = 0;
        btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
        if (call AMSend.send(AM_BROADCAST_ADDR,
            &pkt, sizeof(ControlMsg)) == SUCCESS) {
          busy = TRUE;
        }
      }
    }
  }

  event void Button.pinvalueFDone(error_t err){
    if(err == SUCCESS){
      //发送按键f的命令
      if (!busy) {
        ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
        if (btrpkt == NULL) {
          return;
        }
        btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType;
        btrpkt->op = 2;
        btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
        if (call AMSend.send(AM_BROADCAST_ADDR,
            &pkt, sizeof(ControlMsg)) == SUCCESS) {
          busy = TRUE;
        }
        ControlMsg* btrpkt2 =
        (ControlMsg*)(call Packet.getPayload(&pkt2, sizeof(ControlMsg)));
        if (btrpkt2 == NULL) {
          return;
        }
        btrpkt2->nodeid = TOS_NODE_ID;
        btrpkt2->type = angleType2;
        btrpkt2->op = 2;
        btrpkt2->data = 1000/AM_BROADCAST_ADDR*100;
        if (call AMSend.send(AM_BROADCAST_ADDR,
            &pkt2, sizeof(ControlMsg)) == SUCCESS) {
          busy = TRUE;
        }
      }
    }
  }

  event void Read1.readDone(error_t err, uint16_t value){
    //遥感X输入
    if(err == SUCCESS){
      joyStickX = value;
      readX = TRUE;
      bool left, right, forward, back;
      left = right = forward = back = FALSE;
      if(readX == TRUE && readY = TRUE){
        if(joyStickY <= 0xFF8 - 0x30){
          forward = TRUE;
        }
        else if(joyStickY >= 0xFF8 + 0x30){
          back = TRUE;
        }
        if(joyStickX <= 0xFF8 - 0x30){
          left = TRUE;
        }
        else if(joyStickX >= 0xFF8 + 0x30){
          right = TRUE;
        }
        if(forward == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = forwardType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        else if(back == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = backType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        else if(back == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = backType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        if(left == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = leftType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        else if(right == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = rightType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        if(right = FALSE && left = FALSE && forward = FALSE && back == FALSE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = pauseType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        readX = FALSE;
        readY = FALSE;
      }
    }
  }

  event void Read1.readDone(error_t err, uint16_t value){
    //遥感Y输入
    if(err == SUCCESS){
      joyStickY = value
      readY = TRUE;
      bool left, right, forward, back;
      left = right = forward = back = FALSE;
      if(readX == TRUE && readY = TRUE){
        if(joyStickY <= 0xFF8 - 0x30){
          forward = TRUE;
        }
        else if(joyStickY >= 0xFF8 + 0x30){
          back = TRUE;
        }
        if(joyStickX <= 0xFF8 - 0x30){
          left = TRUE;
        }
        else if(joyStickX >= 0xFF8 + 0x30){
          right = TRUE;
        }
        if(forward == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = forwardType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        else if(back == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = backType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        else if(back == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = backType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        if(left == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = leftType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        else if(right == TRUE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = rightType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        if(right = FALSE && left = FALSE && forward = FALSE && back == FALSE){
          if (!busy) {
            ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&pkt, sizeof(ControlMsg)));
            if (btrpkt == NULL) {
        return;
            }
            btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = pauseType;
            btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            if (call AMSend.send(AM_BROADCAST_ADDR,
                &pkt, sizeof(ControlMsg)) == SUCCESS) {
              busy = TRUE;
            }
          }
        }
        readX = FALSE;
        readY = FALSE;
      }
    }
  }
}
