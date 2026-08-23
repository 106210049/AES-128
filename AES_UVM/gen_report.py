#!/usr/bin/env python3

import os, re, glob, csv
from datetime import datetime
from collections import Counter

# =========================================
# Config
# =========================================
LOG_DIR  = "logs/*.log"
CSV_OUT  = "aes_report.csv"
HTML_OUT = "aes_report.html"

# =========================================
# Regex patterns
# =========================================
RE_PASS   = re.compile(r"\[PASS\]")
RE_FAIL   = re.compile(r"\[FAIL\]")
RE_WARN   = re.compile(r"\[WARN\]")
RE_COVER  = re.compile(r"\[COVER\]")

# Scoreboard
RE_SCB_PASS = re.compile(r"\[SCB\]\[PASS\]")
RE_SCB_FAIL = re.compile(r"\[SCB\]\[FAIL\]|\[SCB\]\[ERR\]")
RE_SVA_PASS = re.compile(r"\[SVA\]\[PASS\]")
RE_SVA_FAIL = re.compile(r"\[SVA\]\[FAIL\]")
RE_SVA_WARN = re.compile(r"\[SVA\]\[WARN\]")
RE_SVA_COVER = re.compile(r"\[SVA\]\[COVER\]")
# Assertion fail message
RE_ASSERT_FAIL = re.compile(r"ASSERT_([A-Z0-9_]+).*?failed", re.MULTILINE)

# =========================================
# Parse one log file
# =========================================
def parse_log(path):
    with open(path, "r", errors="ignore") as f:
        content = f.read()

    testname = os.path.basename(path).replace(".log", "")

    sva_pass  = len(RE_SVA_PASS.findall(content))
    sva_fail  = len(RE_SVA_FAIL.findall(content))
    sva_warn  = len(RE_SVA_WARN.findall(content))
    cover_cnt = len(RE_SVA_COVER.findall(content))

    scb_pass  = len(RE_SCB_PASS.findall(content))
    scb_fail  = len(RE_SCB_FAIL.findall(content))

    failed_asserts = Counter(RE_ASSERT_FAIL.findall(content))

    status = "PASS"
    if sva_fail > 0 or scb_fail > 0:
        status = "FAIL"

    return {
        "test": testname,
        "status": status,
        "sva_pass": sva_pass,
        "sva_fail": sva_fail,
        "sva_warn": sva_warn,
        "cover": cover_cnt,
        "scb_pass": scb_pass,
        "scb_fail": scb_fail,
        "assertions": failed_asserts
    }

# =========================================
# Collect results
# =========================================
results = [parse_log(f) for f in sorted(glob.glob(LOG_DIR))]
results.sort(key=lambda x: x["status"])  # FAIL first

# Global assertion stats
global_asserts = Counter()
for r in results:
    global_asserts.update(r["assertions"])

# =========================================
# CSV report
# =========================================
with open(CSV_OUT, "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["Test","Status","SVA Pass","SVA Fail","SVA Warn","Cover","SCB Pass","SCB Fail"])
    for r in results:
        w.writerow([
            r["test"], r["status"], r["sva_pass"], r["sva_fail"],
            r["sva_warn"], r["cover"], r["scb_pass"], r["scb_fail"]
        ])

# =========================================
# HTML report
# =========================================
now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

html = f"""
<html><head><title>AES Regression Report</title>
<style>
body {{ font-family: Arial; margin:20px; }}
table {{ border-collapse: collapse; width:90%; margin:auto; margin-bottom:30px; }}
th,td {{ border:1px solid #ccc; padding:8px; text-align:center; }}
th {{ background:#333; color:white; }}
.pass {{ background-color:#c8f7c5; }}
.fail {{ background-color:#f7c5c5; }}
</style></head><body>
<h1 align="center">AES Regression Report</h1>
<p align="center">Generated: {now}</p>
"""

# Summary table
html += "<h2 align='center'>Summary</h2><table><tr><th>Test</th><th>Status</th><th>SVA Pass</th><th>SVA Fail</th><th>SVA Warn</th><th>Cover</th><th>SCB Pass</th><th>SCB Fail</th></tr>"
for r in results:
    cls = "pass" if r["status"]=="PASS" else "fail"
    html += f"<tr class='{cls}'><td>{r['test']}</td><td><b>{r['status']}</b></td><td>{r['sva_pass']}</td><td>{r['sva_fail']}</td><td>{r['sva_warn']}</td><td>{r['cover']}</td><td>{r['scb_pass']}</td><td>{r['scb_fail']}</td></tr>"
html += "</table>"

# Assertion summary
html += "<h2 align='center'>Failed Assertions</h2><table><tr><th>Assertion</th><th>Fail Count</th></tr>"
if not global_asserts:
    html += "<tr class='pass'><td colspan='2'><b>No Assertion Failure</b></td></tr>"
else:
    for name,cnt in global_asserts.most_common():
        html += f"<tr class='fail'><td>ASSERT_{name}</td><td>{cnt}</td></tr>"
html += "</table>"

# Overall stats
total_tests = len(results)
pass_tests  = sum(1 for r in results if r["status"]=="PASS")
fail_tests  = total_tests - pass_tests
total_sva_pass = sum(r["sva_pass"] for r in results)
total_sva_fail = sum(r["sva_fail"] for r in results)
total_sva_warn = sum(r["sva_warn"] for r in results)
total_scb_pass = sum(r["scb_pass"] for r in results)
total_scb_fail = sum(r["scb_fail"] for r in results)

html += f"<h2 align='center'>Overall Statistics</h2><table><tr><th>Total Tests</th><th>PASS</th><th>FAIL</th><th>Total SVA PASS</th><th>Total SVA FAIL</th><th>Total SVA WARN</th><th>Total SCB PASS</th><th>Total SCB FAIL</th></tr>"
html += f"<tr><td>{total_tests}</td><td>{pass_tests}</td><td>{fail_tests}</td><td>{total_sva_pass}</td><td>{total_sva_fail}</td><td>{total_sva_warn}</td><td>{total_scb_pass}</td><td>{total_scb_fail}</td></tr></table>"

html += "</body></html>"

with open(HTML_OUT,"w") as f: f.write(html)

print("====================================")
print(" AES Regression report generated")
print("====================================")
print(f"HTML : {HTML_OUT}")
print(f"CSV  : {CSV_OUT}")
print()
print(f"Tests      : {total_tests}")
print(f"PASS       : {pass_tests}")
print(f"FAIL       : {fail_tests}")
print()
print(f"SVA PASS   : {total_sva_pass}")
print(f"SVA FAIL   : {total_sva_fail}")
print(f"SVA WARN   : {total_sva_warn}")
print(f"SCB PASS   : {total_scb_pass}")
print(f"SCB FAIL   : {total_scb_fail}")
print("====================================")
