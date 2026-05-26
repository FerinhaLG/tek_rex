#!/usr/bin/env bash
# Downloads IBM automation documentation:
#   - IBM Z NetView 6.4.0 (latest), fallback to 6.3.0
#   - IBM Z System Automation 4.4.0 (latest), fallback to 4.3.0

DOCS="$(cd "$(dirname "$0")" && pwd)"
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
LOG="$DOCS/download_automation.log"

NV64="https://www.ibm.com/docs/en/SSZJDU_6.4.0/com.ibm.iznetview.doc_6.4.0"
NV63="https://www.ibm.com/docs/en/SSZJDU_6.3.0/com.ibm.iznetview.doc_6.3.0"
SA44="https://www.ibm.com/docs/en/SSWRCJ_4.4.0/pdf"
SA43="https://www.ibm.com/docs/en/SSWRCJ_4.3.0/pdf"

echo "=== Tek-Rex Automation Download $(date) ===" > "$LOG"

# Try primary URL; if 404/403 retry with fallback URL
dl_with_fallback() {
    local folder="$1" outname="$2" primary_url="$3" fallback_url="$4"
    local out="$DOCS/$folder/$outname"

    if [ -f "$out" ] && [ -s "$out" ]; then
        echo "[SKIP] $folder/$outname" | tee -a "$LOG"; return
    fi

    local code
    code=$(curl -s -L -A "$UA" -H "Accept: application/pdf,*/*" \
        --max-time 180 -o "$out" -w "%{http_code}" "$primary_url")

    if [ "$code" = "200" ] && [ -s "$out" ]; then
        local sz; sz=$(du -k "$out" | cut -f1)
        echo "[OK ${sz}KB 6.4/4.4] $folder/$outname" | tee -a "$LOG"
        return
    fi

    rm -f "$out"

    if [ -n "$fallback_url" ]; then
        code=$(curl -s -L -A "$UA" -H "Accept: application/pdf,*/*" \
            --max-time 180 -o "$out" -w "%{http_code}" "$fallback_url")
        if [ "$code" = "200" ] && [ -s "$out" ]; then
            local sz; sz=$(du -k "$out" | cut -f1)
            echo "[OK ${sz}KB FALLBACK] $folder/$outname" | tee -a "$LOG"
            return
        fi
        rm -f "$out"
    fi

    echo "[FAIL $code] $folder/$outname" | tee -a "$LOG"
}
export -f dl_with_fallback
export DOCS UA LOG NV64 NV63 SA44 SA43

echo "--- IBM Z NetView ---"

# NetView: primary=6.4.0, fallback=6.3.0 (same filename, different version path)
dl_with_fallback "netview" "netview_automation_guide.pdf" \
    "$NV64/dqamst.pdf" "$NV63/dqamst.pdf" &

dl_with_fallback "netview" "netview_command_ref_vol1_A-N.pdf" \
    "$NV64/dqc1mst.pdf" "$NV63/dqc1mst.pdf" &

dl_with_fallback "netview" "netview_command_ref_vol2_O-Z.pdf" \
    "$NV64/dqc2mst.pdf" "$NV63/dqc2mst.pdf" &

dl_with_fallback "netview" "netview_installation_getting_started.pdf" \
    "$NV64/inqmst.pdf" "$NV63/inqmst.pdf" &

dl_with_fallback "netview" "netview_installation_configuring_components.pdf" \
    "$NV64/inamst.pdf" "$NV63/inamst.pdf" &

dl_with_fallback "netview" "netview_installation_migration_guide.pdf" \
    "$NV64/inmmst.pdf" "$NV63/inmmst.pdf" &

dl_with_fallback "netview" "netview_messages_codes_vol1_AAU-DSI.pdf" \
    "$NV64/dqm1mst.pdf" "$NV63/dqm1mst.pdf" &

dl_with_fallback "netview" "netview_messages_codes_vol2_DUI-IHS.pdf" \
    "$NV64/dqm2mst.pdf" "$NV63/dqm2mst.pdf" &

dl_with_fallback "netview" "netview_security_reference.pdf" \
    "$NV64/dzlmst.pdf" "$NV63/dzlmst.pdf" &

dl_with_fallback "netview" "netview_users_guide.pdf" \
    "$NV64/dqqmst.pdf" "$NV63/dqqmst.pdf" &

dl_with_fallback "netview" "netview_administration_reference.pdf" \
    "$NV64/dqhmst.pdf" "$NV63/dqhmst.pdf" &

dl_with_fallback "netview" "netview_programming_pipes.pdf" \
    "$NV64/dqsmst.pdf" "$NV63/dqsmst.pdf" &

wait; echo "Batch 1 complete"

dl_with_fallback "netview" "netview_tuning_guide.pdf" \
    "$NV64/dqpmst.pdf" "$NV63/dqpmst.pdf" &

dl_with_fallback "netview" "netview_application_programmers_guide.pdf" \
    "$NV64/dpymst.pdf" "$NV63/dpymst.pdf" &

dl_with_fallback "netview" "netview_programming_rexx.pdf" \
    "$NV64/dqgmst.pdf" "$NV63/dqgmst.pdf" &

dl_with_fallback "netview" "netview_users_guide_aon.pdf" \
    "$NV64/ldwmst.pdf" "$NV63/ldwmst.pdf" &

dl_with_fallback "netview" "netview_ip_management.pdf" \
    "$NV64/cnmimst.pdf" "$NV63/cnmimst.pdf" &

dl_with_fallback "netview" "netview_troubleshooting_guide.pdf" \
    "$NV64/dqrmst.pdf" "$NV63/dqrmst.pdf" &

# Additional NetView books (try both versions)
dl_with_fallback "netview" "netview_messages_codes_vol3_IHS-NPD.pdf" \
    "$NV64/dqm3mst.pdf" "$NV63/dqm3mst.pdf" &

dl_with_fallback "netview" "netview_messages_codes_vol4_NPD-SNE.pdf" \
    "$NV64/dqm4mst.pdf" "$NV63/dqm4mst.pdf" &

wait; echo "Batch 2 complete"

echo ""
echo "--- IBM Z System Automation ---"

# SA: primary=4.4.0, fallback=4.3.0
dl_with_fallback "sa-zos" "sa_getting_started.pdf" \
    "$SA44/Get_Started_Guide.pdf" "$SA43/Get_Started_Guide.pdf" &

dl_with_fallback "sa-zos" "sa_end_to_end_automation.pdf" \
    "$SA44/End-to-End_Automation.pdf" "$SA43/End-to-End_Automation.pdf" &

dl_with_fallback "sa-zos" "sa_users_guide.pdf" \
    "$SA44/User_Guide.pdf" "$SA43/User_Guide.pdf" &

dl_with_fallback "sa-zos" "sa_planning_and_installation.pdf" \
    "$SA44/Planning_and_Installation.pdf" "$SA43/Planning_and_Installation.pdf" &

dl_with_fallback "sa-zos" "sa_operators_commands.pdf" \
    "$SA44/Operator_Commands.pdf" "$SA43/Operator_Commands.pdf" &

dl_with_fallback "sa-zos" "sa_messages_and_codes.pdf" \
    "$SA44/Messages_and_Codes.pdf" "$SA43/Messages_and_Codes.pdf" &

dl_with_fallback "sa-zos" "sa_defining_automation_policy.pdf" \
    "$SA44/Defining_Automation_Policy.pdf" "$SA43/Defining_Automation_Policy.pdf" &

dl_with_fallback "sa-zos" "sa_service_management_unite_automation.pdf" \
    "$SA44/Service_Management_Unite_Automation.pdf" "$SA43/Service_Management_Unite_Automation.pdf" &

wait; echo "Batch 3 complete"

# Additional SA books
dl_with_fallback "sa-zos" "sa_customization_and_administration.pdf" \
    "$SA44/Customization_and_Administration.pdf" "$SA43/Customization_and_Administration.pdf" &

dl_with_fallback "sa-zos" "sa_programmers_reference.pdf" \
    "$SA44/Programmers_Reference.pdf" "$SA43/Programmers_Reference.pdf" &

dl_with_fallback "sa-zos" "sa_whats_new.pdf" \
    "$SA44/Whats_New.pdf" "$SA43/Whats_New.pdf" &

dl_with_fallback "sa-zos" "sa_configuration_guide.pdf" \
    "$SA44/Configuration_Guide.pdf" "$SA43/Configuration_Guide.pdf" &

dl_with_fallback "sa-zos" "sa_sysplex_automation.pdf" \
    "$SA44/Sysplex_Automation.pdf" "$SA43/Sysplex_Automation.pdf" &

dl_with_fallback "sa-zos" "sa_automation_policy_reference.pdf" \
    "$SA44/Automation_Policy_Reference.pdf" "$SA43/Automation_Policy_Reference.pdf" &

wait; echo "Batch 4 complete"

echo ""
echo "=== Done $(date) ==="
ok=$(grep -c "^\[OK"   "$LOG" 2>/dev/null || echo 0)
fail=$(grep -c "^\[FAIL" "$LOG" 2>/dev/null || echo 0)
skip=$(grep -c "^\[SKIP" "$LOG" 2>/dev/null || echo 0)
echo "  Succeeded : $ok"
echo "  Failed    : $fail"
echo "  Skipped   : $skip"
echo ""
if grep -q "^\[FAIL" "$LOG" 2>/dev/null; then
    echo "--- Failures ---"
    grep "^\[FAIL" "$LOG"
fi
