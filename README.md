# Internet NEXTplorer

Gopher browser for ZX Spectrum Next and compatible computers.

![Example of work](readme/demo.gif)

## Important notice!

All traffic goes currently via my personal proxy-server(it splits data by chunks and send it to your computer and don't make anything else). You can check proxy sources [here](https://github.com/nihirash/spectrum-next-gopher-proxy) 

I don't store any data but You should know about it.

But later I'll add possibility use your own proxy server without need to recompile sources. If it's very important for you - say me about it and I'll do it sooner. If you want change proxy to your own now - please edit file `proxy.asm` in `drivers` directory(just replace myown IP address with your). 

Why I did it? Cause Spectrum Next's uart doesn't have flow control and current ESP's firmware sends data to speccy as soon as it received without keeping it in buffer. So, sometimes it ends with data losing. To prevent data losing I did very small proxy that helps us to receive data.

## Development

To compile project all you need is [sjasmplus](https://github.com/z00m128/sjasmplus).

You may use or not use GNU Make. But for just build enought only sjasmplus: `sjasmplus --zxnext=cspect main.asm`

If you want run it in emulator - use CSpect with configured REAL ESP-module! Buildin ESP-emulator doesn't support all necessary commands. 

I've tried organize code for eaiser location all parts and wish you won't have issues with it. If there are some issues with it - feel free write me about it.

To bundle browser include `browser.nex` file and `docs/` directory in single package(should be placed in same directory).

## Usage

Before usage you should have already configured wifi chip(via wifi.bas/wifi2.bas located at demos/esp in Next distro).

Just download latest binary from releases page, extract file to Next's SD card and execute from browser NEX-file.

## Known issues

Font artifacts on file downloading. 

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

You can support me with two ways now:

 - Using [Ko-Fi service](http://ko-fi.com/nihirash) - easy for you and me way(also there's some dev.log)

 - Using Etherium crypto: `0x13105803B79CF6541867d137fDbdf942d0bDA863`

## License

I've licensed project by [Nihirash's Coffeeware License](LICENSE).

Please respect it - it isn't hard.
