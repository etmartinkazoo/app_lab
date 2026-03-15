import { createInertiaApp } from "@inertiajs/react";
import { createRoot } from "react-dom/client";

// Explicit page imports (esbuild doesn't support import.meta.glob)
import Dashboard from "./pages/Dashboard";
import DailyReportsIndex from "./pages/DailyReports/Index";
import DailyReportsShow from "./pages/DailyReports/Show";
import SecurityIndex from "./pages/Security/Index";
import SecurityShow from "./pages/Security/Show";
import SecurityFindingDetail from "./pages/Security/FindingDetail";
import PracticesIndex from "./pages/Practices/Index";
import PracticesShow from "./pages/Practices/Show";
import PracticesItemDetail from "./pages/Practices/ItemDetail";
import InsightsIndex from "./pages/Insights/Index";
import InsightsShow from "./pages/Insights/Show";

const pages = {
  Dashboard,
  "DailyReports/Index": DailyReportsIndex,
  "DailyReports/Show": DailyReportsShow,
  "Security/Index": SecurityIndex,
  "Security/Show": SecurityShow,
  "Security/FindingDetail": SecurityFindingDetail,
  "Practices/Index": PracticesIndex,
  "Practices/Show": PracticesShow,
  "Practices/ItemDetail": PracticesItemDetail,
  "Insights/Index": InsightsIndex,
  "Insights/Show": InsightsShow,
};

createInertiaApp({
  resolve: (name) => {
    const page = pages[name];
    if (!page) {
      throw new Error(
        `Page not found: ${name}. Available: ${Object.keys(pages).join(", ")}`
      );
    }
    return page;
  },
  setup({ el, App, props }) {
    createRoot(el).render(<App {...props} />);
  },
});
