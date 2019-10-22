package main

import (
	"fmt"
	"io"
	"os"
)

func alternate(w io.Writer, base, include string) {
	// Implementation file -> test file or include file (first found)
	fmt.Fprintf(w, "\"%s/src/*.cxx\" : { \"type\": \"source\", \"alternate\": [ \"%s/test/test{}.cxx\", \"%s/include/%s/{}.h\" ] },\n",
		base, base, base, include)
	// include -> implementation or test (first found)
	fmt.Fprintf(w, "\"%s/include/%s/*.h\" : { \"type\": \"header\", \"alternate\": [ \"%s/src/{}.cxx\", \"%s/test/test{}.cxx\" ] },\n",
		base, include, base, base)
	// test -> include or implementation (first found)
	fmt.Fprintf(w, "\"%s/test/test*.cxx\" : { \"type\":\"test\", \"alternate\": [ \"%s/include/%s/{}.h\"] },\n",
		base, base, include)

	// inl files : no alternate, but of type "inl"
	fmt.Fprintf(w, "\"%s/include/%s/*.inl\" : { \"type\" : \"inl\" },\n",
		base, include)
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
	alternate(w, "Detectors/MUON/MCH/Raw", "MCHRaw")
	alternate(w, "Detectors/MUON/MCH/Simulation", "MCHSimulation")
	alternate(w, "Detectors/MUON/MCH/Base", "MCHBase")
	alternate(w, "Detectors/MUON/MCH/Mapping/SegContour", "MCHMappingSegContour")
	alternate(w, "Detectors/MUON/MCH/Mapping/Interface", "MCHMappingInterface")
	//
	alternate(w, "Detectors/MUON/MID/Simulation", "MIDSimulation")
	alternate(w, "Detectors/MUON/MID/Base", "MIDBase")
	alternate(w, "Detectors/MUON/MID/Clustering", "MIDClustering")
	alternate(w, "Detectors/MUON/MID/Tracking", "MIDTracking")
	alternate(w, "Detectors/MUON/MID/TestingSimTools", "MIDTestingSimTools")
	alternate(w, "Detectors/MUON/MID/Workflow", "MIDWorkflow")
	//
	alternate(w, "Common/Field", "Field")
	//
	alternate(w, "Detectors/TPC/simulation", "TPCsimulation")
	alternate(w, "Detectors/TPC/base", "TPCbase")
	alternate(w, "Framework/Core", "Framework")
	alternate(w, "Framework/Foundation", "Framework")
}

func main() {
	generate(os.Stdout)
}
