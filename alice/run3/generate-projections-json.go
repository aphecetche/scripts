package main

import (
	"fmt"
	"io"
	"os"
)

func alternate(w io.Writer, base, include string) {
	fmt.Fprintf(w, "\"%s/include/%s/*.h\" : { \"alternate\":\"%s/src/{}.cxx\" },\n",
		base, include, base)
	fmt.Fprintf(w, "\"%s/src/*.cxx\" : { \"alternate\":\"%s/include/%s/{}.h\" },\n", base, base, include)
}

func generate(w io.Writer) {
	fmt.Fprintf(w, "{\n")
	alternate(w, "Detectors/MUON/MCH/Simulation", "MCHSimulation")
	alternate(w, "Detectors/MUON/MCH/Base", "MCHBase")
	alternate(w, "Detectors/MUON/MCH/Mapping/SegContour", "MCHMappingSegContour")
	alternate(w, "Detectors/MUON/MID/Simulation", "MIDSimulation")
	alternate(w, "Detectors/MUON/MID/Base", "MIDBase")
	alternate(w, "Detectors/MUON/MID/Clustering", "MIDClustering")
	alternate(w, "Detectors/MUON/MID/Tracking", "MIDTracking")
	alternate(w, "Detectors/MUON/MID/TestingSimTools", "MIDTestingSimTools")
	fmt.Fprintf(w, "}\n")
}

func main() {
	// f, err := os.Create(".projections.json")

	generate(os.Stdout)
}

// "             let proj = {  "Detectors/MUON/MCH/Simulation/include/MCHSimulation/*.h" : { "alternate": "Detectors/MUON/MCH/Simulation/src/{}.cxx" },
// "                         \ "Detectors/MUON/MCH/Simulation/src/*.cxx" : { "alternate" : "Detectors/MUON/MCH/Simulation/include/MCHSimulation/{}.h" }
// "                         \ }
