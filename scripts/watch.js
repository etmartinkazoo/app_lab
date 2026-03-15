import { watch } from "chokidar";
import { execSync } from "child_process";

process.env.APP_LAB_SOURCE_MAPS = "true";

const rebuild = (type) => {
  try {
    console.log(`Rebuilding ${type}...`);
    execSync("node scripts/build.js", { stdio: "inherit" });
  } catch (e) {
    console.error(`Rebuild failed: ${e.message}`);
  }
};

console.log("Watching for changes...");

watch("app/javascript/app_lab/**/*.{js,jsx,ts,tsx}", {
  ignoreInitial: true,
}).on("all", () => rebuild("JS"));

watch("app/javascript/app_lab/**/*.css", {
  ignoreInitial: true,
}).on("all", () => rebuild("CSS"));
