all: cspect/test.nex

pages: docs/*.*
	cp -R docs/ cspect/tb/docs

cspect/test.nex: pages main.asm engine/*.* drivers/*.* render/*.* utils/*.*
	sjasmplus --zxnext=cspect main.asm
	cp browser.nex cspect/

test: cspect/test.nex
	cd cspect && mono CSpect.exe -w5 -nextrom -map=test.map -brk -tv -mmc=./../ -zxnext browser.nex
