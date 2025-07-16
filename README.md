Emscripten compiled versions of GotScore 
=========================================

This project creates two variants of the GotScore class from [humlib](https://github.com/craigsapp/humlib/blob/master/src/GotScore.cpp).  

The `e6-wasm` compiled version is for copy-and-pasting into HTML files (see 
gotscore.html for a demo).  Additionally an `e5-asm` version is compiled
for use with Google Apps Script to allow Google sheets to output conversions
of TSV GOT data as Humdrum files.

See the Makefile for more details.

Demo of the stand-alone ECMA Script 6 WebAssembly version (in gotscore.html):


