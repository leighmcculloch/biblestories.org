import $ from "dax/mod.ts";

const langs = ["en", "es-419", "pt-BR", "fr"];

const commonPaths = [
  "css",
  "js",
  "font",
  "favicon-152x152.png",
  "favicon-bg-192x192.png",
];
await Promise.all(
  commonPaths
    .map((p) => langs.map((l) => $`cp -r ./_site/${p} ./_site/${l}/`))
    .flat(),
);

await $`$WRANGLER pages deploy --project-name biblestories-en ./_site/en`;
await $`$WRANGLER pages deploy --project-name biblestories-es-419 ./_site/es-419`;
await $`$WRANGLER pages deploy --project-name biblestories-pt-br ./_site/pt-BR`;
await $`$WRANGLER pages deploy --project-name biblestories-fr ./_site/fr`;
