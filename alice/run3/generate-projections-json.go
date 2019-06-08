package main

import (
	"fmt"
	"io"
	"os"
)

func alternate(w io.Writer, base, include string) {
	fmt.Fprintf(w, "\"%s/include/%s/*.h\" : { \"alternate\": [ \"%s/include/%s/{}.inl\", \"%s/src/{}.cxx\" ] },\n",
		base, include, base, include, base)
	fmt.Fprintf(w, "\"%s/src/*.cxx\" : { \"alternate\":\"%s/include/%s/{}.h\" },\n",
		base, base, include)
	fmt.Fprintf(w, "\"%s/include/%s/*.inl\" : { \"alternate\":\"%s/include/%s/{}.h\" },\n",
		base, include, base, include)
}

func generate(w io.Writer) {
	fmt.Fprintf(w, "{\n")
	generateAlternates(w)

	clangTidyBinary := "/Users/laurent/alice/sw/osx_x86-64/o2codechecker/latest/bin/O2codecheck"

	fmt.Fprintf(w, "\"*.cxx\" : { \"clang-tidy-binary\":\"%s\" }\n",
		clangTidyBinary)
	fmt.Fprintf(w, "}\n")
}

func generateAlternates(w io.Writer) {
	alternate(w, "Detectors/MUON/MCH/Simulation", "MCHSimulation")
	alternate(w, "Detectors/MUON/MCH/Base", "MCHBase")
	alternate(w, "Detectors/MUON/MCH/Mapping/SegContour", "MCHMappingSegContour")
	alternate(w, "Detectors/MUON/MCH/Mapping/Interface", "MCHMappingInterface")
	alternate(w, "Detectors/MUON/MID/Simulation", "MIDSimulation")
	alternate(w, "Detectors/MUON/MID/Base", "MIDBase")
	alternate(w, "Detectors/MUON/MID/Clustering", "MIDClustering")
	alternate(w, "Detectors/MUON/MID/Tracking", "MIDTracking")
	alternate(w, "Detectors/MUON/MID/TestingSimTools", "MIDTestingSimTools")
	alternate(w, "Common/Field", "Field")
	alternate(w, "Detectors/TPC/simulation", "TPCsimulation")
	alternate(w, "Detectors/TPC/base", "TPCbase")
}

func main() {
	generate(os.Stdout)
}
