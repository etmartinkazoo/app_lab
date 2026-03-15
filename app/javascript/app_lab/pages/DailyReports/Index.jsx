import Layout from "../../components/Layout";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "../../components/ui/card";
import { Badge } from "../../components/ui/badge";
import { Button } from "../../components/ui/button";
import { Link } from "@inertiajs/react";
import { Eye, CheckCircle, Clock, AlertCircle } from "lucide-react";

function StatusBadge({ status }) {
  const config = {
    pending: { variant: "secondary", icon: Clock, label: "Pending" },
    processing: { variant: "warning", icon: Clock, label: "Processing" },
    completed: { variant: "success", icon: CheckCircle, label: "Completed" },
    failed: { variant: "destructive", icon: AlertCircle, label: "Failed" },
  };
  const { variant, icon: Icon, label } = config[status] || config.pending;
  return (
    <Badge variant={variant} className="flex items-center gap-1">
      <Icon className="h-3 w-3" />
      {label}
    </Badge>
  );
}

export default function DailyReportsIndex({ reports, pagination }) {
  return (
    <Layout title="Daily Reports">
      <div className="space-y-4">
        {reports && reports.length > 0 ? (
          reports.map((report) => (
            <Card key={report.id}>
              <CardHeader className="flex flex-row items-center justify-between">
                <div className="space-y-1">
                  <CardTitle className="text-base">{report.date}</CardTitle>
                  <div className="flex items-center gap-2">
                    <StatusBadge status={report.status} />
                    {report.reviewed && (
                      <Badge variant="success">Reviewed</Badge>
                    )}
                    <span className="text-sm text-muted-foreground">
                      {report.commit_count} commits
                    </span>
                  </div>
                </div>
                <Link href={`/app_lab/daily_reports/${report.id}`}>
                  <Button variant="outline" size="sm">
                    <Eye className="h-4 w-4 mr-1" />
                    View
                  </Button>
                </Link>
              </CardHeader>
              {report.summary && (
                <CardContent>
                  <p className="text-sm text-muted-foreground line-clamp-2">
                    {report.summary}
                  </p>
                </CardContent>
              )}
            </Card>
          ))
        ) : (
          <Card>
            <CardContent className="py-8 text-center">
              <p className="text-muted-foreground">
                No daily reports yet. Reports are generated automatically each
                morning.
              </p>
            </CardContent>
          </Card>
        )}
      </div>
    </Layout>
  );
}
