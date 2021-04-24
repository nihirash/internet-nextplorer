all: cspect/test.nex

cspect/test.nex: main.asm engine/*.* drivers/*.* render/*.* utils/*.*
	sjasmplus --zxnext=cspect main.asm
	cp browser.nex cspect/

test: cspect/test.nex
	cd cspect && mono CSpect.exe -w3 -nextrom -map=test.map -brk -tv -mmc=./../ -zxnext browser.nex
