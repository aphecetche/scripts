package main

import (
	"flag"
	"fmt"
	"io"
	"os"
	"path"
)

func alternate(w io.Writer, base, include string) {
	// alternates for a "regular" directory with src include test subdirs
	// test -> include or implementation (first found)
	fmt.Fprintf(w, "\"%s/src/test*.cxx\" : { \"type\":\"test\", \"alternate\": [ \"%s/include/%s/{}.h\", \"%s/src/{}.cxx\" ] },\n",
		base, base, include, base)
	// Implementation file -> test file or include file (first found)
	fmt.Fprintf(w, "\"%s/src/*.cxx\" : { \"type\": \"source\", \"alternate\": [ \"%s/test/test{}.cxx\", \"%s/src/test{}.cxx\", \"%s/include/%s/{}.h\" ] },\n",
		base, base, base, base, include)
	// include -> implementation or test (first found)
	fmt.Fprintf(w, "\"%s/include/%s/*.h\" : { \"type\": \"header\", \"alternate\": [ \"%s/src/{}.cxx\", \"%s/test/test{}.cxx\", \"%s/src/test{}.cxx\" ] },\n",
		base, include, base, base, base)
	// test -> include or implementation (first found)
	fmt.Fprintf(w, "\"%s/test/test*.cxx\" : { \"type\":\"test\", \"alternate\": [ \"%s/include/%s/{}.h\"] },\n",
		base, base, include)

	// inl files : no alternate, but of type "inl"
	fmt.Fprintf(w, "\"%s/include/%s/*.inl\" : { \"type\" : \"inl\" },\n",
		base, include)
}

func alternateCompactSub(w io.Writer, base, include string) {
	// alternates for directory where sources and tests are in the same
	// sub directory
	//
	// test -> include or implementation (first found)
	fmt.Fprintf(w, "\"%s/test*.cxx\" : { \"type\":\"test\", \"alternate\": [ \"%s/%s/{}.h\", \"%s/{}.cxx\" ] },\n",
		base, base, include, base)
	// Implementation file -> test file or include file (first found)
	fmt.Fprintf(w, "\"%s/*.cxx\" : { \"type\": \"source\", \"alternate\": [ \"%s/test{}.cxx\", \"%s/%s/{}.h\" ] },\n",
		base, base, base, include)
	// include -> implementation or test (first found)
	fmt.Fprintf(w, "\"%s/%s/*.h\" : { \"type\": \"header\", \"alternate\": [ \"%s/{}.cxx\", \"%s/test{}.cxx\" ] },\n",
		base, include, base, base)

	// inl files : no alternate, but of type "inl"
	fmt.Fprintf(w, "\"%s/%s/*.inl\" : { \"type\" : \"inl\" },\n",
		base, include)
}

func generate(w io.Writer, qc bool) {
	fmt.Fprintf(w, "{\n")

	if qc {
		generateAlternatesQualityControl(w)
	} else {
		generateAlternates(w)
	}

	clangTidyBinary := "/Users/laurent/alice/sw/osx_x86-64/o2codechecker/latest/bin/O2codecheck"

	fmt.Fprintf(w, "\"*.cxx\" : { \"clang-tidy-binary\":\"%s\" }\n",
		clangTidyBinary)
	fmt.Fprintf(w, "}\n")
}

func generateAlternatesQualityControl(w io.Writer) {
	alternate(w, "Modules/MCH", "MCH")
	alternate(w, "Framework", "QualityControl")
}
func generateAlternates(w io.Writer) {
	alternate(w, "Detectors/MUON/MCH/Raw/Decoder", "MCHRawDecoder")
	alternateCompactSub(w, "Detectors/MUON/MCH/Raw/EncoderPayload", "MCHRawEncoderPayload")
	alternate(w, "Detectors/MUON/MCH/Raw/Common", "MCHRawCommon")
	alternate(w, "Detectors/MUON/MCH/Raw/ElecMap", "MCHRawElecMap")
	alternate(w, "Detectors/MUON/MCH/Simulation", "MCHSimulation")
	alternate(w, "Detectors/MUON/MCH/Base", "MCHBase")
	alternate(w, "Detectors/MUON/MCH/Mapping/SegContour", "MCHMappingSegContour")
	alternate(w, "Detectors/MUON/MCH/Mapping/Interface", "MCHMappingInterface")
	alternate(w, "Detectors/MUON/MCH/Mapping/Factory", "MCHMappingFactory")
	alternate(w, "Detectors/MUON/MCH/PreClustering", "MCHPreClustering")
	alternate(w, "Detectors/MUON/MCH/Workflow", "MCHWorkflow")
	alternate(w, "Detectors/MUON/MCH/Geometry/Creator", "MCHGeometryCreator")
	alternate(w, "Detectors/MUON/MCH/Geometry/Transformer", "MCHGeometryTransformer")
	alternate(w, "Detectors/MUON/MCH/Conditions", "MCHConditions")
	//
	alternate(w, "Detectors/MUON/MID/Simulation", "MIDSimulation")
	alternate(w, "Detectors/MUON/MID/Base", "MIDBase")
	alternate(w, "Detectors/MUON/MID/Clustering", "MIDClustering")
	alternate(w, "Detectors/MUON/MID/Tracking", "MIDTracking")
	alternate(w, "Detectors/MUON/MID/TestingSimTools", "MIDTestingSimTools")
	alternate(w, "Detectors/MUON/MID/Workflow", "MIDWorkflow")
	alternate(w, "Detectors/MUON/MID/Raw", "MIDRaw")
	//
	alternate(w, "Common/Field", "Field")
	//
	alternate(w, "Steer", "Steer")
	//
	alternate(w, "Detectors/Raw", "DetectorsRaw")
	alternate(w, "Detectors/DCS", "DetectorsDCS")
	//
	alternate(w, "Detectors/TPC/simulation", "TPCsimulation")
	alternate(w, "Detectors/TPC/base", "TPCbase")
	//
	alternate(w, "Common/Constants", "CommonConstants")
	alternate(w, "Common/Utils", "CommonUtils")
	//
	alternate(w, "Framework/Core", "Framework")
	alternate(w, "Framework/Foundation", "Framework")
	alternate(w, "Framework/Utils", "DPLUtils")
	//
	alternate(w, "DataFormats/common", "CommonDataFormat")
	alternate(w, "DataFormats/Headers", "Headers")
	alternate(w, "DataFormats/Detectors/Common", "DetectorsCommonDataFormats")

	a := []string{"EMCAL", "FIT/FDD", "FIT/FT0", "FIT/FV0", "ITSMFT/ITS", "ITSMFT/MFT", "MUON/MID", "TOF", "TPC"}
	for _, det := range a {
		alternate(w, "DataFormats/Detectors/"+det, "DataFormats"+path.Base(det))
	}
}

func main() {
	var qc = flag.Bool("qc", false, "generate for QualityControl instead of O2")

	flag.Parse()
	generate(os.Stdout, *qc)

}
