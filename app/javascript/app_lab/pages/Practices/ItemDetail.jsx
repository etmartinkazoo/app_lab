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
import { CheckCircle, ExternalLink } from "lucide-react";

export default function PracticeItemDetail({ item, check_history }) {
  return (
    <Layout title={item.name}>
      <Card className="mb-6">
        <CardHeader>
          <CardTitle>{item.name}</CardTitle>
          <CardDescription>
            {item.category.name} | Weight: {item.weight}
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <p className="text-sm">{item.description}</p>
          {item.documentation_url && (
            <a
              href={item.documentation_url}
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-1 text-sm text-blue-600 hover:underline"
            >
              <ExternalLink className="h-3 w-3" />
              Documentation
            </a>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">Check History</CardTitle>
        </CardHeader>
        <CardContent>
          {check_history && check_history.length > 0 ? (
            <div className="space-y-2">
              {check_history.map((check, i) => (
                <div
                  key={i}
                  className="flex items-center justify-between rounded-lg border p-3"
                >
                  <div className="flex items-center gap-2">
                    <Badge
                      variant={
                        check.status === "passed" ? "success" : "destructive"
                      }
                    >
                      {check.status}
                    </Badge>
                    <span className="text-sm text-muted-foreground">
                      by {check.checked_by || "system"}
                    </span>
                  </div>
                  <span className="text-xs text-muted-foreground">
                    {check.checked_at &&
                      new Date(check.checked_at).toLocaleString()}
                  </span>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">No checks yet.</p>
          )}
        </CardContent>
      </Card>
    </Layout>
  );
}
