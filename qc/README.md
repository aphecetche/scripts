# Some jq examples to manipulate qc config files

## Set CCDB host on all json files in the current directory

### Local CCDB on port 6464

```shell
find . -name '*.json' -exec sh -c "jq '.qc.config.database.host |= \"localhost:6464\"' {} > {}.tmp && mv {}.tmp {}" \;
```

### Test CCDB

```shell
find . -name '*.json' -exec sh -c "jq '.qc.config.database.host |= \"ccdb-test.cern.ch:8080\"' {} > {}.tmp && mv {}.tmp {}" \;
```

### Production QCDB

```shell
find . -name '*.json' -exec sh -c "jq '.qc.config.database.host |= \"ali-qcdb.cern.ch:8083\"' {} > {}.tmp && mv {}.tmp {}" \;
```

## Merge JSON files

`qc-workflow.sh` method :

```
jq -n 'reduce inputs as $s (input; .qc.tasks += ($s.qc.tasks) | .qc.checks += ($s.qc.checks)  | .qc.externalTasks += ($s.qc.externalTasks) | .qc.postprocessing += ($s.qc.postprocessing)| .dataSamplingPolicies += ($s.dataSamplingPolicies))' $QC_JSON_GLOBAL $JSON_FILES 
```

Failed attempt to get it simpler, which is ok, for tasks and checks, but not for dataSamplingPolicies unfortunately...

```shell
jq '.[0] * .[1]' mch-digits.json qc-global.json
```
