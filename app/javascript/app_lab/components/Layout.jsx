import { Link, usePage } from "@inertiajs/react";
import {
  LayoutDashboard,
  GitCommit,
  Shield,
  CheckSquare,
  Lightbulb,
} from "lucide-react";
import { cn } from "../lib/utils";

const navigation = [
  { name: "Dashboard", href: "/app_lab", icon: LayoutDashboard },
  { name: "Commits", href: "/app_lab/daily_reports", icon: GitCommit },
  { name: "Security", href: "/app_lab/security_scans", icon: Shield },
  { name: "Practices", href: "/app_lab/practices", icon: CheckSquare },
  { name: "Insights", href: "/app_lab/insights", icon: Lightbulb },
];

export default function Layout({ children, title }) {
  const { url } = usePage();

  return (
    <div className="min-h-screen bg-background">
      {/* Sidebar */}
      <aside className="fixed inset-y-0 left-0 z-50 w-64 border-r border-border bg-sidebar-background">
        <div className="flex h-16 items-center gap-2 border-b border-border px-6">
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground text-sm font-bold">
            AL
          </div>
          <span className="text-lg font-semibold">App Lab</span>
        </div>

        <nav className="flex flex-col gap-1 p-4">
          {navigation.map((item) => {
            const isActive =
              url === item.href || url.startsWith(item.href + "/");
            const Icon = item.icon;
            return (
              <Link
                key={item.name}
                href={item.href}
                className={cn(
                  "flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors",
                  isActive
                    ? "bg-sidebar-accent text-sidebar-accent-foreground font-medium"
                    : "text-muted-foreground hover:bg-sidebar-accent hover:text-sidebar-accent-foreground"
                )}
              >
                <Icon className="h-4 w-4" />
                {item.name}
              </Link>
            );
          })}
        </nav>
      </aside>

      {/* Main content */}
      <main className="pl-64">
        <header className="sticky top-0 z-40 flex h-16 items-center gap-4 border-b border-border bg-background/95 px-8 backdrop-blur supports-[backdrop-filter]:bg-background/60">
          <h1 className="text-lg font-semibold">{title}</h1>
        </header>

        <div className="p-8">{children}</div>
      </main>
    </div>
  );
}
