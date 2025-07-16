// GotScoreBindings.cpp
#include <emscripten/bind.h>
#include "GotScore.h"

using namespace emscripten;
using hum::GotScore;

EMSCRIPTEN_BINDINGS(GotScore_module) {
  class_<GotScore>("GotScore")
    // bind the default constructor
    .constructor<>()

    // bind loadLines(const std::string&)
    // (this overload parses the entire string as TSV)
    .function(
      "loadLines",
      select_overload<void(const std::string&)>(&GotScore::loadLines)
    )

    // bind the two “export” methods
    .function("getGotHumdrum", &GotScore::getGotHumdrum)
    .function("getKernHumdrum", &GotScore::getKernHumdrum)
    ;
}

