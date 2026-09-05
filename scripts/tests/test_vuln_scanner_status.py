"""Contract checks, not a claim that a model followed the reporting instructions."""
from pathlib import Path
import unittest

SKILL = (Path(__file__).resolve().parents[2] / "skills/vuln-scanner/SKILL.md").read_text()


class ScannerStatusContract(unittest.TestCase):
    def test_report_preserves_history_status(self):
        report = SKILL.split("### A7. Write local report", 1)[1].split("### A8.", 1)[0]
        self.assertIn("trufflehog-git", report)
        self.assertIn("sources.txt", report)

    def test_both_notification_templates_preserve_history_status(self):
        notify = SKILL.split("### A8. Notify", 1)[1].split("## Arm D", 1)[0]
        rows = [line for line in notify.splitlines() if "Scanners:" in line]
        self.assertEqual(len(rows), 2)
        for row in rows:
            self.assertIn("trufflehog-git=<ok|fail|timeout>", row)

    def test_log_preserves_history_status(self):
        log = SKILL.split("## Log", 1)[1].split("## Network note", 1)[0]
        self.assertIn("trufflehog-git=ok|fail|timeout", log)


if __name__ == "__main__":
    unittest.main()
