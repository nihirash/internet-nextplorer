    MODULE Input

read:
    call Keyboard.inkey
    and a : ret nz

    in a, ($1f) // port A
    call Joystick.readJoystick
    and a : ret nz

    in a, ($37) // port B
    call Joystick.readJoystick

    ret

waitForButtonUp:
    call Keyboard.waitForKeyUp

    in a, ($1f) // port A
    call Joystick.waitForButtonUp

    in a, ($37) // port B
    call Joystick.waitForButtonUp

    ENDMODULE
