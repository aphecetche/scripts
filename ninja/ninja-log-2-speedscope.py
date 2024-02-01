#!/usr/bin/env python3

import sys
import re


def read_logfile(log):
    header = log.readline()
    m = re.search(r'^# ninja log v(\d+)\n$', header)
    assert m, "unrecognized ninja log version %r" % header
    version = int(m.group(1))
    assert 5 <= version <= 6, "unsupported ninja log version %d" % version
    if version == 6 or version == 5:
        # Skip header line
        next(log)

    targets = {}
    last_end_seen = 0
    for line in log:
        # Ignore restat.
        start, end, _, name, cmdhash = line.strip().split('\t')
        if re.match("CMakeFiles", name):
            continue
        if int(end) < last_end_seen:
            # An earlier time stamp means that this step is the first in a new
            # build, possibly an incremental build. Throw away the previous data
            # so that this new build will be displayed independently.
            targets = {}
        last_end_seen = int(end)
        if cmdhash in targets:
            targets[cmdhash]['name'] += " " + name
        else:
            t = {
                'start': int(start),
                'end': int(end),
                'name': name,
                'group': '-',
                'duration': int((int(end)-int(start))/1000)
            }
            targets[cmdhash] = t
    return sorted(targets.values(), key=lambda x: x['duration'], reverse=True)


def group_targets(targets):
    groups = [
        "^examples",
        "^examples/JDynamics",
        "^examples/JReconstruction",
        "^examples/JTrigger",
        "^software",
        "^software/JAAnet",
        "^software/JAcoustics",
        "^software/JCalibrate",
        "^software/JCompass",
        "^software/JDB",
        "^software/JDataFilter",
        "^software/JDetector",
        "^software/JDynamics",
        "^software/JGizmo",
        "^software/JMonitor",
        "^software/JPhysics",
        "^software/JReconstruction",
        "^software/JRunAnalyzer",
        "^software/JDataQuality",
        "^software/AcousticDataFilter",
        "^software/JSirene",
        "^software/JSupernova",
        "^software/JTimeslice",
        "^software/JTrigger",
        "^software/JDataWriter",
        "^tests"
    ]
    for t in targets:
        group = "-"
        name = t['name']
        for g in groups:
            if re.search(g, name):
                group = g.replace("/", ";")
                group = group.replace("^", "")
        if re.search("G__", name):
            group = "dict"
        if re.search("^software/.*Data.*", name):
            group = "software;DAQ"
        if re.search("test", name):
            group = "test;{}".format(group)
        t['group'] = group
    return targets


with open(sys.argv[1], 'r') as log:
    targets = read_logfile(log)

targets = group_targets(targets)

for t in targets:
    print("{};{} {}".format(t['group'], t['name'], t['duration']))
