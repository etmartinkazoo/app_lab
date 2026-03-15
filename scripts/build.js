import { execSync } from "child_process";
import { existsSync, mkdirSync } from "fs";

const outputDir = "public/app-lab-assets";
const sourceMaps = !!process.env.APP_LAB_SOURCE_MAPS;

if (!existsSync(outputDir)) {
  mkdirSync(outputDir, { recursive: true });
}

console.log("Building App Lab assets...");

try {
  // Build CSS with Tailwind
  console.log("  Building CSS...");
  execSync(
    `npx @tailwindcss/cli -i app/javascript/app_lab/styles/application.css -o ${outputDir}/app-lab.css ${sourceMaps ? "" : "--minify"}`,
    { stdio: "inherit" }
  );

  // Build JS with esbuild
  console.log("  Building JS...");
  execSync(
    `npx esbuild app/javascript/app_lab/application.jsx --bundle --format=esm --target=es2020 --outfile=${outputDir}/app-lab.js ${sourceMaps ? "--sourcemap" : "--minify"} --loader:.jsx=jsx --loader:.tsx=tsx --jsx=automatic`,
    { stdio: "inherit" }
  );

  console.log("Build complete!");
} catch (error) {
  console.error("Build failed:", error.message);
  process.exit(1);
}
