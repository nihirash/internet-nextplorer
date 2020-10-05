all: cspect/test.nex

pages: *.gph
	cp *.gph cspect/tb/

cspect/test.nex: pages main.asm engine/*.* drivers/*.* render/*.* utils/*.*
	sjasmplus --zxnext=cspect main.asm
	cp test.nex cspect/

test: cspect/test.nex
	cd cspect && mono CSpect.exe -w4 -nextrom -map=test.map -brk -tv -mmc=./tb/ -zxnext test.nex
