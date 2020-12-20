# Internet NEXTplorer

Gopher browser for ZX Spectrum Next and compatible computers.

![Example of work](readme/demo.gif)

## Development

To compile project all you need is [sjasmplus](https://github.com/z00m128/sjasmplus).

You may use or not use GNU Make. But for just build enought only sjasmplus: `sjasmplus --zxnext=cspect main.asm`

If you want run it in emulator - use CSpect with configured REAL ESP-module! Buildin ESP-emulator doesn't support all necessary commands. But if you want run it in CSpect with buildin emulator there is some hack(but it will work very bad):

 * Found in `drivers` directory file `wifi.asm`.
 
 * Comment this lines:

 ```
    EspCmdOkErr "AT+CIPSERVER=0" 
    EspCmdOkErr "AT+CIPDINFO=0" ; Disable additional info
    jr c, .initError
```

And this

 ```
    call Uart.read : cp 'S' : jr nz, getPacket
    call Uart.read : cp 'E' : jr nz, getPacket
    call Uart.read : cp 'D' : jr nz, getPacket
    call Uart.read : cp 13 : jr nz, getPacket
```

 * Build entire project and run it with cspect using this keys `-nextrom -tv -mmc=./../ -zxnext browser.nex`

I've tried organize code for eaiser location all parts and wish you won't have issues with it. If there are some issues with it - feel free write me about it.

To bundle browser include `browser.nex` file and `docs/` directory in single package(should be placed in same directory).

## Usage

Before usage you should have already configured wifi chip(via wifi.bas/wifi2.bas located at demos/esp in Next distro). 

Best stablitiy I've got with [this](https://github.com/Threetwosevensixseven/espupdate/tree/master/fw/ESP8266_FULL_V3.3_SPUGS/NONOS_v200_1300) wifi-chip firmware.

How to install it?

 * Download `NONOS_v200_1300.esp` from link that I've written before.

 * Put it to Next's SD card

 * Just open it via Next's browser. After process compete - reconfigure your chip again(via wifi.bas/wifi2.bas)

This firmware works good with uGophy, Internet NEXTplorer, nxtel, nxftp and other tools. Also with this firmware i've got less data losing.

When you did all this parts(or skipped updating firmware on ESP-chip) - just download latest binary from releases page, extract file to Next's SD card and execute from browser NEX-file.

## Known issues

Still not possible download files. Sorry.

Some ESP's firmwares sends data too fast - so we got data losing(for example, you can got image without attributes). 

I have some ideas how to fix them both in single fix.

## Development plan
- [X] Publish first version and get first happy users
- [X] Fix history bugs
- [X] Make history multilevel
- [X] Add file downloads using proxy server
- [ ] Add mouse support
- [ ] Automatic change song to next(if it goes as next link on page)
- [ ] Same for screens
- [ ] Support more graphic formats?!
- [ ] Support more music formats?!

## Sponsorship

Github sponsorship isn't available for Russia.

You can support my work via PayPal(attached email written in [LICENSE file](LICENSE)).

Thank you.

## License

I've licensed project by [Nihirash's Coffeeware License](LICENSE).

Please respect it - it isn't hard.