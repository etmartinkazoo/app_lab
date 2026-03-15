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
import { Progress } from "../../components/ui/progress";
import { router } from "@inertiajs/react";
import {
  CheckCircle,
  XCircle,
  Clock,
  MinusCircle,
  Play,
} from "lucide-react";

const statusConfig = {
  passed: { icon: CheckCircle, color: "text-green-600", label: "Passed" },
  failed: { icon: XCircle, color: "text-red-600", label: "Failed" },
  in_progress: { icon: Clock, color: "text-yellow-600", label: "In Progress" },
  not_started: {
    icon: MinusCircle,
    color: "text-gray-400",
    label: "Not Started",
  },
  na: { icon: MinusCircle, color: "text-gray-400", label: "N/A" },
};

export default function PracticesShow({ category, items }) {
  const handleToggle = (itemId) => {
    router.post(`/app_lab/items/${itemId}/toggle`);
  };

  const handleVerify = (itemId) => {
    router.post(`/app_lab/items/${itemId}/verify`);
  };

  return (
    <Layout title={category.name}>
      <Card className="mb-6">
        <CardHeader>
          <CardTitle>{category.name}</CardTitle>
          <CardDescription>{category.description}</CardDescription>
        </CardHeader>
        <CardContent>
          <Progress value={category.completion} />
          <p className="text-sm text-muted-foreground mt-2">
            {category.completion}% complete
          </p>
        </CardContent>
      </Card>

      <div className="space-y-3">
        {items &&
          items.map((item) => {
            const config =
              statusConfig[item.status] || statusConfig.not_started;
            const StatusIcon = config.icon;
            return (
              <Card key={item.id}>
                <CardContent className="py-4">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <StatusIcon className={`h-5 w-5 ${config.color}`} />
                      <div>
                        <div className="flex items-center gap-2">
                          <p className="text-sm font-medium">{item.name}</p>
                          {item.is_critical && (
                            <Badge variant="destructive" className="text-xs">
                              Critical
                            </Badge>
                          )}
                          <Badge variant="outline" className="text-xs">
                            {item.verification_type}
                          </Badge>
                        </div>
                        <p className="text-xs text-muted-foreground">
                          {item.description}
                        </p>
                      </div>
                    </div>
                    <div className="flex gap-2">
                      {item.verification_type !== "manual" && (
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleVerify(item.id)}
                        >
                          <Play className="h-3 w-3 mr-1" />
                          Verify
                        </Button>
                      )}
                      <Button
                        variant={
                          item.status === "passed" ? "secondary" : "default"
                        }
                        size="sm"
                        onClick={() => handleToggle(item.id)}
                      >
                        {item.status === "passed" ? "Uncheck" : "Check"}
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
      </div>
    </Layout>
  );
}
