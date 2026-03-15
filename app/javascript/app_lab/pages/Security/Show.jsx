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
import { Link } from "@inertiajs/react";
import { Shield, FileCode, ExternalLink } from "lucide-react";

const severityConfig = {
  critical: { variant: "destructive", label: "Critical" },
  high: { variant: "destructive", label: "High" },
  medium: { variant: "warning", label: "Medium" },
  low: { variant: "secondary", label: "Low" },
  info: { variant: "outline", label: "Info" },
};

export default function SecurityShow({ scan, findings }) {
  return (
    <Layout title={`Security Scan - ${scan.scan_type}`}>
      {/* Scan Summary */}
      <Card className="mb-6">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Shield className="h-5 w-5" />
            {scan.scan_type} Scan Results
          </CardTitle>
          <CardDescription>
            Completed{" "}
            {scan.completed_at && new Date(scan.completed_at).toLocaleString()}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-5 gap-4 text-center">
            <div>
              <div className="text-2xl font-bold">{scan.total_issues}</div>
              <div className="text-xs text-muted-foreground">Total</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-red-600">
                {scan.critical_count}
              </div>
              <div className="text-xs text-muted-foreground">Critical</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-orange-600">
                {scan.high_count}
              </div>
              <div className="text-xs text-muted-foreground">High</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-yellow-600">
                {scan.medium_count}
              </div>
              <div className="text-xs text-muted-foreground">Medium</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-gray-600">
                {scan.low_count}
              </div>
              <div className="text-xs text-muted-foreground">Low</div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Findings */}
      <div className="space-y-3">
        <h2 className="text-lg font-semibold">
          Findings ({findings.length})
        </h2>
        {findings.map((finding) => {
          const severity = severityConfig[finding.severity] || severityConfig.info;
          return (
            <Card key={finding.id}>
              <CardContent className="py-4">
                <div className="flex items-start justify-between">
                  <div className="space-y-1 flex-1">
                    <div className="flex items-center gap-2">
                      <Badge variant={severity.variant}>
                        {severity.label}
                      </Badge>
                      {finding.category && (
                        <Badge variant="outline">{finding.category}</Badge>
                      )}
                      {finding.cwe_id && (
                        <span className="text-xs text-muted-foreground">
                          CWE-{finding.cwe_id}
                        </span>
                      )}
                    </div>
                    <p className="text-sm">{finding.description}</p>
                    {finding.file_path && (
                      <p className="text-xs text-muted-foreground flex items-center gap-1">
                        <FileCode className="h-3 w-3" />
                        {finding.file_path}
                        {finding.line_number && `:${finding.line_number}`}
                      </p>
                    )}
                  </div>
                  <Link href={`/app_lab/security_findings/${finding.id}`}>
                    <Button variant="ghost" size="sm">
                      <ExternalLink className="h-4 w-4" />
                    </Button>
                  </Link>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>
    </Layout>
  );
}
