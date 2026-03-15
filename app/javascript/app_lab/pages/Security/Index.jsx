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
import { Shield, Play, Eye, AlertTriangle } from "lucide-react";

export default function SecurityIndex({ scans, trends }) {
  const handleTriggerScan = () => {
    router.post("/app_lab/security_scans/trigger");
  };

  return (
    <Layout title="Security Scans">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className="text-lg font-semibold">Security Scan History</h2>
          <p className="text-sm text-muted-foreground">
            Automated security scanning with OWASP compliance
          </p>
        </div>
        <Button onClick={handleTriggerScan}>
          <Play className="h-4 w-4 mr-1" />
          Trigger Scan
        </Button>
      </div>

      <div className="space-y-4">
        {scans && scans.length > 0 ? (
          scans.map((scan) => (
            <Card key={scan.id}>
              <CardHeader className="flex flex-row items-center justify-between">
                <div className="space-y-1">
                  <CardTitle className="text-base flex items-center gap-2">
                    <Shield className="h-4 w-4" />
                    {scan.scan_type}
                  </CardTitle>
                  <CardDescription>
                    {scan.completed_at
                      ? new Date(scan.completed_at).toLocaleString()
                      : "In progress..."}
                    {scan.duration && ` (${Math.round(scan.duration)}s)`}
                  </CardDescription>
                </div>
                <div className="flex items-center gap-2">
                  {scan.critical_count > 0 && (
                    <Badge variant="destructive" className="flex items-center gap-1">
                      <AlertTriangle className="h-3 w-3" />
                      {scan.critical_count} critical
                    </Badge>
                  )}
                  {scan.high_count > 0 && (
                    <Badge variant="destructive">
                      {scan.high_count} high
                    </Badge>
                  )}
                  <Badge variant="outline">
                    {scan.total_issues} total
                  </Badge>
                  <Link href={`/app_lab/security_scans/${scan.id}`}>
                    <Button variant="outline" size="sm">
                      <Eye className="h-4 w-4" />
                    </Button>
                  </Link>
                </div>
              </CardHeader>
            </Card>
          ))
        ) : (
          <Card>
            <CardContent className="py-8 text-center">
              <Shield className="h-8 w-8 mx-auto mb-2 text-muted-foreground" />
              <p className="text-muted-foreground">
                No security scans yet. Click "Trigger Scan" to run your first
                scan.
              </p>
            </CardContent>
          </Card>
        )}
      </div>
    </Layout>
  );
}
