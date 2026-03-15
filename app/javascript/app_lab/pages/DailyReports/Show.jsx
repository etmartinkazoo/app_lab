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
import {
  GitCommit,
  RefreshCw,
  CheckCircle,
  AlertTriangle,
} from "lucide-react";

const categoryColors = {
  feature: "default",
  fix: "destructive",
  refactor: "secondary",
  chore: "outline",
  dependency: "warning",
  security: "destructive",
};

export default function DailyReportShow({ report, commits }) {
  const handleRegenerate = () => {
    router.post(`/app_lab/daily_reports/${report.id}/regenerate_summary`);
  };

  const handleMarkReviewed = () => {
    router.post(`/app_lab/daily_reports/${report.id}/mark_reviewed`);
  };

  return (
    <Layout title={`Report - ${report.date}`}>
      {/* Report Header */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>{report.date}</CardTitle>
              <CardDescription>
                {report.commit_count} commits
                {report.reviewed && ` | Reviewed by ${report.reviewed_by}`}
              </CardDescription>
            </div>
            <div className="flex gap-2">
              <Button variant="outline" size="sm" onClick={handleRegenerate}>
                <RefreshCw className="h-4 w-4 mr-1" />
                Regenerate
              </Button>
              {!report.reviewed && (
                <Button size="sm" onClick={handleMarkReviewed}>
                  <CheckCircle className="h-4 w-4 mr-1" />
                  Mark Reviewed
                </Button>
              )}
            </div>
          </div>
        </CardHeader>
        {report.summary && (
          <CardContent>
            <div className="prose prose-sm max-w-none">{report.summary}</div>
          </CardContent>
        )}
      </Card>

      {/* Commits List */}
      <div className="mt-6 space-y-3">
        <h2 className="text-lg font-semibold">Commits</h2>
        {commits.map((commit) => (
          <Card key={commit.id}>
            <CardContent className="py-4">
              <div className="flex items-start justify-between">
                <div className="flex items-start gap-3">
                  <GitCommit className="h-4 w-4 mt-1 text-muted-foreground" />
                  <div>
                    <p className="text-sm font-medium">{commit.message}</p>
                    <p className="text-xs text-muted-foreground mt-1">
                      {commit.sha.substring(0, 8)} by {commit.author}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  {commit.is_breaking && (
                    <Badge variant="destructive" className="flex items-center gap-1">
                      <AlertTriangle className="h-3 w-3" />
                      Breaking
                    </Badge>
                  )}
                  {commit.category && (
                    <Badge variant={categoryColors[commit.category] || "outline"}>
                      {commit.category}
                    </Badge>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </Layout>
  );
}
