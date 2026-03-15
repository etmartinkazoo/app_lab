import Layout from "../../components/Layout";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "../../components/ui/card";
import { Progress } from "../../components/ui/progress";
import { Link } from "@inertiajs/react";
import { CheckSquare, ArrowRight } from "lucide-react";

export default function PracticesIndex({ categories, overall_score }) {
  return (
    <Layout title="Best Practices">
      {/* Overall Score */}
      <Card className="mb-6">
        <CardHeader>
          <CardTitle>Overall Health Score</CardTitle>
          <CardDescription>
            How well your application follows best practices
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-4">
            <div className="text-4xl font-bold">
              {Math.round(overall_score)}%
            </div>
            <Progress value={overall_score} className="flex-1" />
          </div>
        </CardContent>
      </Card>

      {/* Categories */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {categories &&
          categories.map((category) => (
            <Link
              key={category.id}
              href={`/app_lab/practices/${category.id}`}
            >
              <Card className="hover:shadow-md transition-shadow cursor-pointer h-full">
                <CardHeader>
                  <div className="flex items-center justify-between">
                    <CardTitle className="text-base flex items-center gap-2">
                      <CheckSquare className="h-4 w-4" />
                      {category.name}
                    </CardTitle>
                    <ArrowRight className="h-4 w-4 text-muted-foreground" />
                  </div>
                  <CardDescription>{category.description}</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-2">
                    <div className="flex justify-between text-sm">
                      <span className="text-muted-foreground">
                        {category.item_count} items
                      </span>
                      <span className="font-medium">
                        {category.completion}%
                      </span>
                    </div>
                    <Progress value={category.completion} />
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
      </div>
    </Layout>
  );
}
