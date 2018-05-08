build:
	jbuilder build
	jbuilder build test/test.exe
	ln -fs ./_build/default/test/test.exe main

test:
	jbuilder runtest

clean:
	rm -rf _build main

.PHONY: test clean
