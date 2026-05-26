#!/usr/bin/env bash
# Downloads all z/OS 3.1 IBM documentation PDFs

BASE="https://www.ibm.com/docs/en/SSLTBW_3.1.0/pdf"
DOCS="$(cd "$(dirname "$0")" && pwd)"
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
LOG="$DOCS/download.log"
PARALLEL=8

dl() {
    local folder="$1" filename="$2"
    local out="$DOCS/$folder/$filename"
    if [ -f "$out" ] && [ -s "$out" ]; then
        echo "[SKIP] $folder/$filename" | tee -a "$LOG"; return
    fi
    local code
    code=$(curl -s -L -A "$UA" -H "Accept: application/pdf,*/*" \
        --max-time 180 -o "$out" -w "%{http_code}" "$BASE/$filename")
    if [ "$code" = "200" ] && [ -s "$out" ]; then
        local sz; sz=$(du -k "$out" | cut -f1)
        echo "[OK ${sz}KB] $folder/$filename" | tee -a "$LOG"
    else
        rm -f "$out"
        echo "[FAIL $code] $folder/$filename" | tee -a "$LOG"
    fi
}

run_batch() {
    local pids=()
    for args in "$@"; do
        IFS=$'\x1f' read -r folder filename <<< "$args"
        dl "$folder" "$filename" &
        pids+=($!)
    done
    for pid in "${pids[@]}"; do wait "$pid"; done
}

echo "=== Tek-Rex z/OS 3.1 Download $(date) ===" > "$LOG"

# Each entry: folder<US>filename  (US = ASCII unit separator 0x1F, no quoting issues)
S=$'\x1f'
JOBS=(
  # z/OS MVS / BCP
  "zos-mvs${S}ieab600_v3r1.pdf"
  "zos-mvs${S}ieab500_v3r1.pdf"
  "zos-mvs${S}ieag100_v3r1.pdf"
  "zos-mvs${S}ieah700_v3r1.pdf"
  "zos-mvs${S}ieag200_v3r1.pdf"
  "zos-mvs${S}ieam100_v3r1.pdf"
  "zos-mvs${S}ieam200_v3r1.pdf"
  "zos-mvs${S}ieam300_v3r1.pdf"
  "zos-mvs${S}ieam400_v3r1.pdf"
  "zos-mvs${S}ieam500_v3r1.pdf"
  "zos-mvs${S}ieam600_v3r1.pdf"
  "zos-mvs${S}ieam700_v3r1.pdf"
  "zos-mvs${S}ieam800_v3r1.pdf"
  "zos-mvs${S}ieam900_v3r1.pdf"
  "zos-mvs${S}ieama00_v3r1.pdf"
  "zos-mvs${S}ieae100_v3r1.pdf"
  "zos-mvs${S}ieae200_v3r1.pdf"
  "zos-mvs${S}ieaw100_v3r1.pdf"
  "zos-mvs${S}ieaf100_v3r1.pdf"
  "zos-mvs${S}ieab100_v3r1.pdf"
  "zos-mvs${S}ieag400_v3r1.pdf"
  "zos-mvs${S}ieag300_v3r1.pdf"

  # z/OS UNIX System Services
  "zos-unix${S}bpxa400_v3r1.pdf"
  "zos-unix${S}bpxb200_v3r1.pdf"
  "zos-unix${S}bpxa600_v3r1.pdf"
  "zos-unix${S}bpxa800_v3r1.pdf"
  "zos-unix${S}foto100_v3r1.pdf"

  # TSO/E and REXX
  "tso-rexx${S}ikjc300_v3r1.pdf"
  "tso-rexx${S}ikja300_v3r1.pdf"
  "tso-rexx${S}ikjc200_v3r1.pdf"
  "tso-rexx${S}ikjc500_v3r1.pdf"
  "tso-rexx${S}ikjp100_v3r1.pdf"
  "tso-rexx${S}ikjb400_v3r1.pdf"

  # RACF / Security Server
  "racf${S}icha700_v3r1.pdf"
  "racf${S}icha400_v3r1.pdf"
  "racf${S}icha600_v3r1.pdf"
  "racf${S}icha100_v3r1.pdf"
  "racf${S}icha200_v3r1.pdf"

  # JES2
  "jes${S}hasa200_v3r1.pdf"
  "jes${S}hasa300_v3r1.pdf"
  "jes${S}hasa400_v3r1.pdf"

  # DFSMS / SMS
  "sms${S}idad400_v3r1.pdf"
  "sms${S}idac100_v3r1.pdf"
  "sms${S}idad500_v3r1.pdf"
  "sms${S}idai200_v3r1.pdf"
  "sms${S}idas200_v3r1.pdf"
  "sms${S}idak100_v3r1.pdf"
  "sms${S}idarc00_v3r1.pdf"

  # ISPF
  "ispf${S}f54ug00_v3r1.pdf"
  "ispf${S}f54u200_v3r1.pdf"
  "ispf${S}f54sg00_v3r1.pdf"
  "ispf${S}f54dg00_v3r1.pdf"
  "ispf${S}f54rs00_v3r1.pdf"

  # SMF + RMF
  "smf-rmf${S}erbru00_v3r1.pdf"
  "smf-rmf${S}erbb500_v3r1.pdf"
  "smf-rmf${S}erba200_v3r1.pdf"

  # Networking / Communications Server
  "networking${S}halz001_v3r1.pdf"
  "networking${S}halz002_v3r1.pdf"
  "networking${S}halu001_v3r1.pdf"
  "networking${S}halu101_v3r1.pdf"
  "networking${S}cs3cod0_v3r1.pdf"
  "networking${S}istimp0_v3r1.pdf"
  "networking${S}istrdr0_v3r1.pdf"
  "networking${S}istmnc0_v3r1.pdf"
  "networking${S}halw001_v3r1.pdf"
  "networking${S}halb001_v3r1.pdf"
  "networking${S}halb101_v3r1.pdf"

  # Utilities
  "utilities${S}idau100_v3r1.pdf"
  "utilities${S}icea100_v3r1.pdf"
  "utilities${S}iceg200_v3r1.pdf"

  # SDSF
  "sdsf${S}isfa500_v3r1.pdf"

  # z/OSMF
  "zosmf${S}izua300_v3r1.pdf"
  "zosmf${S}izua700_v3r1.pdf"
)

total=${#JOBS[@]}
echo "Total PDFs: $total — parallel: $PARALLEL"

# Process in batches of $PARALLEL
for (( i=0; i<total; i+=PARALLEL )); do
    batch=("${JOBS[@]:$i:$PARALLEL}")
    run_batch "${batch[@]}"
    echo "Completed batch $((i/PARALLEL + 1)) / $(( (total + PARALLEL - 1) / PARALLEL ))"
done

echo ""
echo "=== Done $(date) ==="
echo ""
ok=$(grep -c "^\[OK"   "$LOG" 2>/dev/null || echo 0)
fail=$(grep -c "^\[FAIL" "$LOG" 2>/dev/null || echo 0)
skip=$(grep -c "^\[SKIP" "$LOG" 2>/dev/null || echo 0)
echo "  Succeeded : $ok"
echo "  Failed    : $fail"
echo "  Skipped   : $skip"
echo ""
if [ "$fail" -gt 0 ]; then
    echo "--- Failures ---"
    grep "^\[FAIL" "$LOG"
fi
