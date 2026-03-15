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
import { Lightbulb, CheckCircle, EyeOff, FileCode } from "lucide-react";

export default function InsightShow({ finding }) {
  const handleResolve = () => {
    router.post(`/app_lab/insights/${finding.id}/resolve`);
  };

  const handleIgnore = () => {
    router.post(`/app_lab/insights/${finding.id}/ignore`);
  };

  return (
    <Layout title="Insight Detail">
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="flex items-center gap-2">
                <Lightbulb className="h-5 w-5" />
                {finding.title}
              </CardTitle>
              <CardDescription>
                {finding.rule?.name} | {finding.category}
              </CardDescription>
            </div>
            {finding.status === "open" && (
              <div className="flex gap-2">
                <Button variant="outline" size="sm" onClick={handleIgnore}>
                  <EyeOff className="h-4 w-4 mr-1" />
                  Ignore
                </Button>
                <Button size="sm" onClick={handleResolve}>
                  <CheckCircle className="h-4 w-4 mr-1" />
                  Resolve
                </Button>
              </div>
            )}
          </div>
        </CardHeader>
        <CardContent className="space-y-6">
          {finding.description && (
            <div>
              <h3 className="text-sm font-semibold mb-2">Description</h3>
              <p className="text-sm">{finding.description}</p>
            </div>
          )}

          {finding.file_path && (
            <div>
              <h3 className="text-sm font-semibold mb-2">Location</h3>
              <p className="text-sm flex items-center gap-1">
                <FileCode className="h-4 w-4" />
                {finding.file_path}
                {finding.line_number && `:${finding.line_number}`}
              </p>
            </div>
          )}

          {finding.code_snippet && (
            <div>
              <h3 className="text-sm font-semibold mb-2">Code</h3>
              <pre className="rounded-lg bg-muted p-4 text-sm overflow-x-auto">
                <code>{finding.code_snippet}</code>
              </pre>
            </div>
          )}

          {finding.suggested_fix && (
            <div>
              <h3 className="text-sm font-semibold mb-2">Suggested Fix</h3>
              <div className="rounded-lg bg-green-50 dark:bg-green-900/20 p-4 text-sm">
                {finding.suggested_fix}
              </div>
            </div>
          )}

          {finding.rule?.documentation_url && (
            <div>
              <a
                href={finding.rule.documentation_url}
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm text-blue-600 hover:underline"
              >
                View documentation
              </a>
            </div>
          )}
        </CardContent>
      </Card>
    </Layout>
  );
}
