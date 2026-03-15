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
import { Link, router } from "@inertiajs/react";
import { Lightbulb, Play, Eye, FileCode } from "lucide-react";

const severityConfig = {
  critical: { variant: "destructive", label: "Critical" },
  high: { variant: "destructive", label: "High" },
  medium: { variant: "warning", label: "Medium" },
  low: { variant: "secondary", label: "Low" },
};

export default function InsightsIndex({ findings, summary }) {
  const handleScan = () => {
    router.post("/app_lab/insights/scan");
  };

  return (
    <Layout title="Insights">
      {/* Summary Cards */}
      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <Card>
          <CardContent className="pt-6">
            <div className="text-2xl font-bold">{summary?.total_open || 0}</div>
            <p className="text-xs text-muted-foreground">Open</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="text-2xl font-bold">
              {summary?.total_in_progress || 0}
            </div>
            <p className="text-xs text-muted-foreground">In Progress</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="text-2xl font-bold text-red-600">
              {summary?.critical || 0}
            </div>
            <p className="text-xs text-muted-foreground">Critical</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="text-2xl font-bold text-green-600">
              {summary?.resolved_this_week || 0}
            </div>
            <p className="text-xs text-muted-foreground">Resolved This Week</p>
          </CardContent>
        </Card>
      </div>

      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-semibold">Findings</h2>
        <Button onClick={handleScan}>
          <Play className="h-4 w-4 mr-1" />
          Run Scan
        </Button>
      </div>

      <div className="space-y-3">
        {findings && findings.length > 0 ? (
          findings.map((finding) => {
            const severity =
              severityConfig[finding.severity] || severityConfig.low;
            return (
              <Card key={finding.id}>
                <CardContent className="py-4">
                  <div className="flex items-start justify-between">
                    <div className="space-y-1">
                      <div className="flex items-center gap-2">
                        <Badge variant={severity.variant}>
                          {severity.label}
                        </Badge>
                        <Badge variant="outline">{finding.effort}</Badge>
                        <span className="text-xs text-muted-foreground">
                          {finding.category}
                        </span>
                      </div>
                      <p className="text-sm font-medium">{finding.title}</p>
                      {finding.file_path && (
                        <p className="text-xs text-muted-foreground flex items-center gap-1">
                          <FileCode className="h-3 w-3" />
                          {finding.file_path}
                        </p>
                      )}
                    </div>
                    <Link href={`/app_lab/insights/${finding.id}`}>
                      <Button variant="ghost" size="sm">
                        <Eye className="h-4 w-4" />
                      </Button>
                    </Link>
                  </div>
                </CardContent>
              </Card>
            );
          })
        ) : (
          <Card>
            <CardContent className="py-8 text-center">
              <Lightbulb className="h-8 w-8 mx-auto mb-2 text-muted-foreground" />
              <p className="text-muted-foreground">
                No insights yet. Run a scan to detect optimization
                opportunities.
              </p>
            </CardContent>
          </Card>
        )}
      </div>
    </Layout>
  );
}
