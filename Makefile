build:
	jbuilder build test/test.exe
	ln -fs ./_build/default/test/test.exe main

clean:
	rm -rf _build main
