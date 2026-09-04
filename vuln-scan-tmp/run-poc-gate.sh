#!/usr/bin/env bash
set -euo pipefail
export VULN_POC_RESULTS_DIR=/home/runner/work/svectors-lab/svectors-lab/vuln-scan-tmp/poc-results
export VULN_POC_DIR=/home/runner/work/svectors-lab/svectors-lab/vuln-scan-tmp/poc
export VULN_POC_EXEC_LOG=/home/runner/work/svectors-lab/svectors-lab/vuln-scan-tmp/poc-executions.log
mkdir -p "$VULN_POC_RESULTS_DIR"
/home/runner/work/svectors-lab/svectors-lab/scripts/vuln-poc-gate.sh command \
  --finding /home/runner/work/svectors-lab/svectors-lab/vuln-scan-tmp/poc/finding-1.json \
  --repo /home/runner/work/svectors-lab/svectors-lab/hermes-agent \
  --script /home/runner/work/svectors-lab/svectors-lab/vuln-scan-tmp/poc/finding-1.sh
