#include <Timer.h>
#include "BlinkToRadio.h"

module BlinkToRadioC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
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
  message_t sendMessage[6];
  message_t* ONE_NOK sendQueue[6];
  uint16_t send_point = 0;
  uint16_t receive_point = 0;
  uint16_t MIN_ANGLE = 500;
  uint16_t MAX_ANGLE = 4500;
  uint16_t angle1 = 3000;
  uint16_t angle2 = 3000;
  bool busy = FALSE;
  bool full = FALSE;
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
    uint8_t i;
    call Button.Start();
    call AMControl.start();
    for(i = 0 ; i < 6; i ++){
        sendQueue[i] = &sendMessage[i];
    }
  }

  task void SendTask(){
    atomic{
      if(send_point == receive_point && !full){
        busy = FALSE;
        return;
      }
      if(call AMSend.send(AM_BROADCAST_ADDR,sendQueue[send_point],sizeof(ControlMsg)) == SUCCESS){
        call Leds.led2Toggle();
        busy = FALSE;
      }
      else{
        post SendTask();
      }
    }
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
      call Timer1.startPeriodic(200);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }


  event void Timer1.fired(){
    if(!busy){
      post SendTask();
      busy = TRUE;
    }
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
    if (&sendMessage[send_point] == msg) {
      busy = FALSE;
      send_point ++;
      if(send_point == 6){
        send_point = 0;
      }
      full = FALSE;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(BlinkToRadioMsg)) {
      BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
      setLeds(btrpkt->counter);
    }
    return msg;
  }

  event void Button.PinValueADone(error_t err){
    if(err == SUCCESS){
      //发送按键a的命令
      call Leds.led0Toggle();
      if (!full) {
        ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
        if (btrpkt == NULL) {
          return;
        }
        //btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType;
        //btrpkt->op = 1;
        angle1 -= 300;
        if(angle1 <= MIN_ANGLE){
          angle1 == MIN_ANGLE;
        }
        btrpkt->data = angle1;
        receive_point ++;
        if(receive_point == 6){
          receive_point = 0;
        }
        if(receive_point == send_point){
          full = TRUE;
        }
      }
    }
  }

  event void Button.PinValueBDone(error_t err){
    if(err == SUCCESS){
      //发送按键a的命令
      call Leds.led0Toggle();
      if (!full) {
        ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
        if (btrpkt == NULL) {
          return;
        }
        //btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType;
        //btrpkt->op = 0;
        angle1 += 300;
        if(angle1 >= MAX_ANGLE){
          angle1 == MAX_ANGLE;
        }
        btrpkt->data = angle1;
        receive_point ++;
        if(receive_point == 6){
          receive_point = 0;
        }
        if(receive_point == send_point){
          full = TRUE;
        }
      }
    }
  }

  event void Button.PinValueCDone(error_t err){
    if(err == SUCCESS){
      //发送按键a的命令
      call Leds.led0Toggle();
      if (!full) {
        ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
        if (btrpkt == NULL) {
          return;
        }
        //btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType2;
        //btrpkt->op = 1;
        angle2 += 300;
        if(angle2 >= MAX_ANGLE){
          angle2 == MAX_ANGLE;
        }
        btrpkt->data = angle2;
        receive_point ++;
        if(receive_point == 6){
          receive_point = 0;
        }
        if(receive_point == send_point){
          full = TRUE;
        }
      }
    }
  }

  event void Button.PinValueDDone(error_t err){
    if(err == SUCCESS){
      //发送按键d的命令
    }
  }

  event void Button.PinValueEDone(error_t err){
    if(err == SUCCESS){
      //发送按键a的命令
      call Leds.led0Toggle();
      if (!full) {
        ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
        if (btrpkt == NULL) {
          return;
        }
        //btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType2;
        //btrpkt->op = 0;
        angle2 -= 300;
        if(angle2 >= MIN_ANGLE){
          angle2 == MIN_ANGLE;
        }
        btrpkt->data = angle2;
        receive_point ++;
        if(receive_point == 6){
          receive_point = 0;
        }
        if(receive_point == send_point){
          full = TRUE;
        }
      }
    }
  }

  event void Button.PinValueFDone(error_t err){
    if(err == SUCCESS){
      //发送按键a的命令
      call Leds.led0Toggle();
      if (!full) {
        ControlMsg* btrpkt =
        (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
        if (btrpkt == NULL) {
          return;
        }
        //btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType;
        //btrpkt->op = 2;
        angle1 = 3000;
        btrpkt->data = angle1;
        receive_point ++;
        if(receive_point == 6){
          receive_point = 0;
        }
        if(receive_point == send_point){
          full = TRUE;
        }
        btrpkt =
        (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
        if (btrpkt == NULL) {
          return;
        }
        //btrpkt->nodeid = TOS_NODE_ID;
        btrpkt->type = angleType2;
        //btrpkt->op = 2;
        angle2 = 3000;
        btrpkt->data = angle2;
        receive_point ++;
        if(receive_point == 6){
          receive_point = 0;
        }
        if(receive_point == send_point){
          full = TRUE;
        }
      }
    }
  }

  event void Read1.readDone(error_t err, uint16_t value){
    //遥感X输入
    if(err == SUCCESS){
      bool left, right;
      call Leds.led1Toggle();
      joyStickX = value;
      readX = TRUE;
      left = FALSE;
      right = FALSE;
      if(joyStickX <= 2048 - 500){
        left = TRUE;
      }
      else if(joyStickX >= 2048 + 500){
        right = TRUE;
      }
      if(left == TRUE){
        if (!full) {
          ControlMsg* btrpkt =
          (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
          if (btrpkt == NULL) {
            return;
          }
          //btrpkt->nodeid = TOS_NODE_ID;
          btrpkt->type = forwardType;
          //btrpkt->op = 1;
          btrpkt->data = 400;
          receive_point ++;
          if(receive_point == 6){
            receive_point = 0;
          }
          if(receive_point == send_point){
            full = TRUE;
          }
        }
      }
      else if(right == TRUE){
        if (!full) {
          ControlMsg* btrpkt =
          (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
          if (btrpkt == NULL) {
            return;
          }
          //btrpkt->nodeid = TOS_NODE_ID;
          btrpkt->type = backType;
          //btrpkt->op = 1;
          btrpkt->data = 400;
          receive_point ++;
          if(receive_point == 6){
            receive_point = 0;
          }
          if(receive_point == send_point){
            full = TRUE;
          }
        }
      }
      if(right == FALSE && left == FALSE){
        readX = FALSE;
      }
    }
  }

  event void Read2.readDone(error_t err, uint16_t value){
    //遥感Y输入
    if(err == SUCCESS){
      bool left, right, forward, back;
      call Leds.led1Toggle();
      joyStickY = value;
      readY = TRUE;
      forward = FALSE;
      back = FALSE;
      if(joyStickY <= 2048 - 500){
        forward = TRUE;
      }
      else if(joyStickY >= 2048 + 500){
        back = TRUE;
      }
      if(forward == TRUE){
        if (!full) {
          ControlMsg* btrpkt =
          (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
          if (btrpkt == NULL) {
            return;
          }
          //btrpkt->nodeid = TOS_NODE_ID;
          btrpkt->type = leftType;
          //btrpkt->op = 1;
          btrpkt->data = 600;
          receive_point ++;
          if(receive_point == 6){
            receive_point = 0;
          }
          if(receive_point == send_point){
            full = TRUE;
          }
        }
      }
      else if(back == TRUE){
        if (!full) {
          ControlMsg* btrpkt =
          (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
          if (btrpkt == NULL) {
            return;
          }
          //btrpkt->nodeid = TOS_NODE_ID;
          btrpkt->type = rightType;
          //btrpkt->op = 1;
          btrpkt->data = 600;
          receive_point ++;
          if(receive_point == 6){
            receive_point = 0;
          }
          if(receive_point == send_point){
            full = TRUE;
          }
        }
      }
      if(forward == FALSE && back == FALSE){
        readY = FALSE;
        if(readX == FALSE && readY == FALSE){
          if (!full) {
            ControlMsg* btrpkt =
            (ControlMsg*)(call Packet.getPayload(&sendMessage[receive_point], sizeof(ControlMsg)));
            if (btrpkt == NULL) {
              return;
            }
            //btrpkt->nodeid = TOS_NODE_ID;
            btrpkt->type = pauseType;
            //btrpkt->op = 1;
            btrpkt->data = 1000/AM_BROADCAST_ADDR*100;
            receive_point ++;
            if(receive_point == 6){
              receive_point = 0;
            }
            if(receive_point == send_point){
              full = TRUE;
            }
          }
        }
      }
    }
  }
  event void Button.StopDone(error_t error){}
  event void Button.StartDone(error_t error){}
}
