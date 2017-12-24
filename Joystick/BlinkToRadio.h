// $Id: BlinkToRadio.h,v 1.4 2006/12/12 18:22:52 vlahan Exp $

#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

enum {
  AM_BLINKTORADIO = 6,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct BlinkToRadioMsg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
  nx_uint16_t type; //类型位
  nx_uint16_t data; //数据位
} BlinkToRadioMsg;

typedef nx_struct ControlMsg {
  //nx_uint16_t nodeid;
  //nx_uint16_t op; // 1加法，0减法， 2归位
  nx_uint16_t type; //类型位
  nx_uint16_t data; //数据位
} ControlMsg;

#endif
