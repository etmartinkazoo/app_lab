import Layout from "../components/Layout";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "../components/ui/card";
import { Badge } from "../components/ui/badge";
import { Progress } from "../components/ui/progress";
import { Link } from "@inertiajs/react";
import {
  GitCommit,
  Shield,
  CheckSquare,
  Lightbulb,
  AlertTriangle,
  ArrowRight,
} from "lucide-react";

function SeverityBadge({ severity }) {
  const variants = {
    critical: "destructive",
    high: "destructive",
    medium: "warning",
    low: "secondary",
  };
  return <Badge variant={variants[severity] || "secondary"}>{severity}</Badge>;
}

export default function Dashboard({
  latest_report,
  security_summary,
  practice_score,
  recent_insights,
}) {
  return (
    <Layout title="Dashboard">
      {/* Summary Cards */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {/* Commits Card */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">
              Today's Commits
            </CardTitle>
            <GitCommit className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {latest_report ? (
              <>
                <div className="text-2xl font-bold">
                  {latest_report.commit_count}
                </div>
                <p className="text-xs text-muted-foreground">
                  {latest_report.reviewed ? "Reviewed" : "Pending review"}
                </p>
              </>
            ) : (
              <p className="text-sm text-muted-foreground">No report yet</p>
            )}
          </CardContent>
        </Card>

        {/* Security Card */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">
              Security Issues
            </CardTitle>
            <Shield className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {security_summary ? (
              <>
                <div className="text-2xl font-bold">
                  {security_summary.open_findings}
                </div>
                <p className="text-xs text-muted-foreground">
                  {security_summary.critical_count} critical
                </p>
              </>
            ) : (
              <p className="text-sm text-muted-foreground">No scans yet</p>
            )}
          </CardContent>
        </Card>

        {/* Practices Card */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">
              Practice Score
            </CardTitle>
            <CheckSquare className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {practice_score ? (
              <>
                <div className="text-2xl font-bold">
                  {practice_score.grade}
                </div>
                <Progress value={practice_score.overall_score} className="mt-2" />
                <p className="text-xs text-muted-foreground mt-1">
                  {practice_score.passed_count}/{practice_score.total_items}{" "}
                  passed
                </p>
              </>
            ) : (
              <p className="text-sm text-muted-foreground">Not scored yet</p>
            )}
          </CardContent>
        </Card>

        {/* Insights Card */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">
              Open Insights
            </CardTitle>
            <Lightbulb className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {recent_insights?.length || 0}
            </div>
            <p className="text-xs text-muted-foreground">
              Actionable suggestions
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Recent Insights */}
      <div className="mt-8">
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle>Recent Insights</CardTitle>
                <CardDescription>
                  Latest actionable suggestions for your codebase
                </CardDescription>
              </div>
              <Link
                href="/app_lab/insights"
                className="flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground"
              >
                View all <ArrowRight className="h-3 w-3" />
              </Link>
            </div>
          </CardHeader>
          <CardContent>
            {recent_insights && recent_insights.length > 0 ? (
              <div className="space-y-4">
                {recent_insights.map((insight) => (
                  <div
                    key={insight.id}
                    className="flex items-center justify-between rounded-lg border border-border p-4"
                  >
                    <div className="space-y-1">
                      <p className="text-sm font-medium">{insight.title}</p>
                      <p className="text-xs text-muted-foreground">
                        {insight.file_path}
                      </p>
                    </div>
                    <div className="flex items-center gap-2">
                      <SeverityBadge severity={insight.severity} />
                      <Badge variant="outline">{insight.effort}</Badge>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-muted-foreground">
                No insights yet. Run an insight scan to get started.
              </p>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Latest Report Summary */}
      {latest_report && latest_report.summary && (
        <div className="mt-4">
          <Card>
            <CardHeader>
              <CardTitle>Latest Commit Summary</CardTitle>
              <CardDescription>{latest_report.date}</CardDescription>
            </CardHeader>
            <CardContent>
              <div
                className="prose prose-sm max-w-none"
                dangerouslySetInnerHTML={{ __html: latest_report.summary }}
              />
            </CardContent>
          </Card>
        </div>
      )}
    </Layout>
  );
}
