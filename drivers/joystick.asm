   MODULE Joystick

JOY_BUTTON_A_BIT = 6
JOY_BUTTON_B_BIT = 4
JOY_UP_BIT = 3
JOY_DOWN_BIT = 2
JOY_LEFT_BIT = 1
JOY_RIGHT_BIT = 0

waitForButtonUp:
   in a, ($1f) // port A
   call readJoystickPort
   and a : jr nz, waitForButtonUp

   in a, ($37) // port B
   call readJoystickPort
   and a : jr nz, waitForButtonUp

   ret

readJoystick:
   in a, ($1f) // port A
   call readJoystickPort
   and a : ret nz

   in a, ($37) // port B
   call readJoystickPort
   ret

readJoystickPort: // translate to KEY_* in register `a`
   bit JOY_UP_BIT, a : jp nz, .joyUp
   bit JOY_DOWN_BIT, a : jp nz, .joyDown
   bit JOY_LEFT_BIT, a : jp nz, .joyLeft
   bit JOY_RIGHT_BIT, a : jp nz, .joyRight
   bit JOY_BUTTON_A_BIT, a : jp nz, .joyBack
   bit JOY_BUTTON_B_BIT, a : jp nz, .joyNavigate
.nothing:
   xor a
   ret

.joyUp
   bit JOY_DOWN_BIT, a : jp nz, .nothing // not connected if up and down are high
   ld a, Keyboard.KEY_UP
   ret

.joyDown
   ld a, Keyboard.KEY_DOWN
   ret

.joyLeft
   ld a, Keyboard.KEY_LEFT
   ret

.joyRight
   ld a, Keyboard.KEY_RIGHT
   ret

.joyNavigate
   ld a, 13
   ret

.joyBack:
   ld a, 'b'
   ret

   ENDMODULE
