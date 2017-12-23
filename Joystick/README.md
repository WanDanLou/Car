# Joystick
typedef nx_struct ControlMsg {
  nx_uint16_t nodeid;
  nx_uint16_t op; // 1加法，0减法， 2归位
  nx_uint16_t type; //类型位
  nx_uint16_t data; //数据位
} ControlMsg;
