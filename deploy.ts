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

for (const l of langs) {
  await $`$WRANGLER pages deploy --project-name biblestories-${l.toLocaleLowerCase()} --branch main ./_site/${l}`;
}
