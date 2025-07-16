## GNU/BSD makefile for compiling GotScore-emscripten
##
## Programmer:    Craig Stuart Sapp <craig@ccrma.stanford.edu>
## Creation Date: Wed Jul 16 12:53:11 CEST 2025
## Last Modified: Wed Jul 16 13:20:42 CEST 2025
## Filename:      GotScore-emscriten/Makefile
##
## Description: Compiles the GotScore converter from TSV to **kern data.
##
## ONB: emcc needs to be installed, see:
##    https://github.com/emscripten-core/emscripten
##    https://emscripten.org/docs/getting_started/index.html
##
## Also to convert ECMA 6 to ECMA 5, babel needs to be installed
##    npm install --save-dev @babel/cli @babel/core @babel/preset-env
##

all:
	@echo
	@echo "make copy    == copy GotScore class from humlib."
	@echo "make e6_wasm == compile to WAM for ECMA 6."
	@echo "make e5_asm  == compile to ASM for ECMA 5 (Google Apps Script)."
	@echo "make clean   == erase Javascript compiled code.
	@echo



##############################
##
## copy -- Copy the most recent GotScore class source code from humlib
##         (provided that it is downloaded and is in a sibling directory
##         to this one.
##

copy:
	cp ../humlib/src/GotScore.cpp .
	cp ../humlib/include/GotScore.h .


##############################
##
## e6-wasm -- Compile for ECMA 6 WebAssembly.  The exectuable
##     is suitable for running on a webpage (see the gotscore.html
##     demo page.
##
##
## Emscripten options:
##
## --bind          Turns on Emscripten's embind support, which is Emscripten’s
##                 way to automatically bind C++ classes/functions to JavaScript.
##
## -s WASM=1       Output WebAssembly code (default).
##
## -s MODULARIZE=1 Wraps your output in a function that returns a Promise
##                 resolving to the module, so it doesn't pollute global scope.
##                   createGotScoreModule().then((Module) => {
##                      // use Module here
##                   });
##
## -s SINGLE_FILE=1 Puts all output JavaScript glue code and the WebAssembly
##                  binary — into a single .js file, by base64-embedding the
##                  wasm.  This is handy for deployment without having to
##                  separately load .wasm files.  This is the method used
##                  in the demo gotscore.html file which embedds the gotscore
##                  program directly in the HTML page.
##
## -s EXPORT_NAME="createGotScoreModule"  Specifies the factory function name
##                  when -s MODULARIZE=1 is used.  Instead of the default Module,
##                  it will give you a callable named createGotScoreModule.
##                  createGotScoreModule().then((Module) => { /* ... */ });
##
## This make target creates the file gotscore-e6-wasm.js which can be 
## copied into gotscore.html (replacing the old copy of e6-wasm present
## in the HTML file.
##

e6-wasm:
	emcc \
	   GotScore.cpp GotScore-bindings.cpp    \
	   -std=c++17                            \
	   -O3                                   \
	   --bind                                \
	   -s WASM=1                             \
	   -s MODULARIZE=1                       \
	   -s SINGLE_FILE=1                      \
	   -s EXPORT_NAME="createGotScoreModule" \
	   -o gotscore-e6-wasm.js


##############################
##
## e5-asm -- ECMA Script 5 ASM version of gotscore program.  Google
##      Apps Script cannot run WebAssembly, so this make target compiles
##      to ASMA.  Google Apps Scripts cannot run ECMA Script version 6, so
##      this target also compiled the ES6 code to ES5.  Compiling to ES5
##      involves running babel installed with npm:
##    npm install --save-dev @babel/cli @babel/core @babel/preset-env
##      Output file is gotscore-ec5-asm.gs, which can be copied
##      into a Google Apps Script project.

e5-asm:
	emcc GotScore.cpp GotScore-bindings.cpp \
	   -std=c++17                           \
	   -O3                                  \
	   --bind                               \
	   -s WASM=0                            \
	   -s MODULARIZE=0                      \
	   -s EXPORT_NAME="Module"              \
	   -o gotscore-ec6-asm.js
	npx babel --no-babelrc                  \
	  --presets=@babel/preset-env           \
	  --compact true                        \
	  gotscore-ec6-asm.js                   \
	  --out-file gotscore-ec5-asm.gs	\



##############################
##
## clean -- Remove compiled JavaScript files.
##

clean:
	-rm -f *.gs *.js



