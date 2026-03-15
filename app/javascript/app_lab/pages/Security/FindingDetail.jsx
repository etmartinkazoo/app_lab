import Layout from "../../components/Layout";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "../../components/ui/card";
import { Badge } from "../../components/ui/badge";
import { Button } from "../../components/ui/button";
import { router } from "@inertiajs/react";
import { Shield, FileCode, CheckCircle, XCircle } from "lucide-react";

export default function FindingDetail({ finding }) {
  const handleResolve = () => {
    router.post(`/app_lab/security_findings/${finding.id}/resolve`, {
      resolution_notes: "Resolved",
    });
  };

  const handleFalsePositive = () => {
    router.post(`/app_lab/security_findings/${finding.id}/mark_false_positive`, {
      resolution_notes: "Marked as false positive",
    });
  };

  return (
    <Layout title="Security Finding">
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Shield className="h-5 w-5" />
                {finding.category || "Security Finding"}
              </CardTitle>
              <CardDescription>
                {finding.file_path}
                {finding.line_number && `:${finding.line_number}`}
                {finding.cwe_id && ` | CWE-${finding.cwe_id}`}
              </CardDescription>
            </div>
            <div className="flex gap-2">
              {finding.status === "open" && (
                <>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={handleFalsePositive}
                  >
                    <XCircle className="h-4 w-4 mr-1" />
                    False Positive
                  </Button>
                  <Button size="sm" onClick={handleResolve}>
                    <CheckCircle className="h-4 w-4 mr-1" />
                    Resolve
                  </Button>
                </>
              )}
            </div>
          </div>
        </CardHeader>
        <CardContent className="space-y-6">
          <div>
            <h3 className="text-sm font-semibold mb-2">Description</h3>
            <p className="text-sm">{finding.description}</p>
          </div>

          {finding.ai_remediation && (
            <div>
              <h3 className="text-sm font-semibold mb-2">
                AI Remediation Suggestion
              </h3>
              <div className="prose prose-sm max-w-none rounded-lg bg-muted p-4">
                {finding.ai_remediation}
              </div>
            </div>
          )}

          {finding.human_remediation && (
            <div>
              <h3 className="text-sm font-semibold mb-2">
                Manual Remediation Notes
              </h3>
              <div className="rounded-lg bg-muted p-4 text-sm">
                {finding.human_remediation}
              </div>
            </div>
          )}

          {finding.resolution_notes && (
            <div>
              <h3 className="text-sm font-semibold mb-2">Resolution</h3>
              <p className="text-sm">{finding.resolution_notes}</p>
            </div>
          )}
        </CardContent>
      </Card>
    </Layout>
  );
}
