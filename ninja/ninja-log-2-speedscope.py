#!/usr/bin/env python

import sys
import re
def read_logfile(log):
    header = log.readline()
    m = re.search(r'^# ninja log v(\d+)\n$', header)
    assert m, "unrecognized ninja log version %r" % header
    version = int(m.group(1))
    assert 5 <= version <= 6, "unsupported ninja log version %d" % version
    if version == 6:
        # Skip header line
        next(log)

    targets = []
    last_end_seen = 0
    for line in log:
        start, end, _, name, cmdhash = line.strip().split('\t') # Ignore restat.
        if int(end) < last_end_seen:
            # An earlier time stamp means that this step is the first in a new
            # build, possibly an incremental build. Throw away the previous data
            # so that this new build will be displayed independently.
            targets = []
        last_end_seen = int(end)
        group = "-"
        groups = [ "^GPU","^Steer","^Detectors","^Framework",
                  "^Framework/Core",
                  "^Framework/TestWorkflows",
                  "^Analysis",
                  "^Detectors/MUON",
                  "^Detectors/MUON/MCH",
                  "^Detectors/MUON/MCH/Simulation",
                  "^Detectors/MUON/MCH/Tracking",
                  "^Detectors/MUON/MCH/PreClustering",
                  "^Detectors/MUON/MCH/Mapping",
                  "^Detectors/MUON/MCH/Raw",
                  "^Detectors/MUON/MCH/Raw/ElecMap",
                  "^Detectors/MUON/MCH/Raw/Encoder",
                  "^Detectors/MUON/MCH/Raw/Decoder",
                  "^Detectors/MUON/MID",
                  "^Detectors/ITSMFT",
                  "^Detectors/ITSMFT/ITS",
                  "^Detectors/ITSMFT/MFT",
                  "^Detectors/ITSMFT/common",
                  "^Detectors/TRD",
                  "^Detectors/FIT",
                  "^Detectors/TOF",
                  "^Detectors/GlobalTracking",
                  "^Detectors/TPC",
                  "^Detectors/PHOS",
                  "^Detectors/EMCAL",
                  "^Detectors/Raw",
                  "^Detectors/CPV",
                  "^Detectors/Base",
                  "^Detectors/HMPID",
                  "^Detectors/gconfig",
                  "^Detectors/ZDC",
                  "^CCDB",
                  "^DataFormats",
                  "^run",
                  "^Generators",
                  "^Utilities",
                  "^Utilities/Merger",
                  "^Utilities/DataFlow",
                  "^Common",
                  "^Common/Field",
                  "^Common/MathUtils",
                  "^Common/Utils",
                  "^Common/SimConfig",
                  "^Examples"

                 ]
        for g in groups:
          if re.search(g,name):
              group = g.replace("/",";")
              group = group.replace("^","")
        if re.search("G__",name):
            group="dict"
            if re.search(".pcm",name):
                group="dict;pcm"
            if re.search(".cxx$",name):
                group="dict;generate"
            if re.search(".o$",name):
                group="dict;link"
        if re.search(".rootmap$",name):
            group="dict;rootmap"
        if re.search("workflow",name):
            group = "workflow;{}".format(group)
        if re.search("test",name):
            group = "test;{}".format(group)
        t = {
            'start': int(start),
            'end': int(end),
            'name':name,
            'group': group,
            'duration': int((int(end)-int(start))/1000)
        }
        targets.append(t)
    return sorted(targets, key=lambda x: x['duration'], reverse=True)

with open(sys.argv[1], 'r') as log: 
    targets = read_logfile(log)

for t in targets:
    print("{};{} {}".format(t['group'],t['name'],t['duration']))
