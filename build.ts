const dev = Deno.env.get("DEV") == "1";

import lume from "lume/mod.ts";
const site = lume({
  src: "./src",
});

site.data("dev", dev);

site.data("langs", [
  {
    lang: "en",
    base_url: dev ? "/en" : "https://biblestories.org",
    bible: "NET",
  },
  {
    lang: "es-419",
    base_url: dev ? "/es-419" : "https://biblestories.org/es",
    bible: "NET",
  },
  {
    lang: "pt-BR",
    base_url: dev ? "/pt-BR" : "https://historiasdabiblia.com.br",
    bible: "NET",
  },
  {
    lang: "fr",
    base_url: dev ? "/fr" : "https://recitsbibliques.com",
    bible: "SG21",
  },
]);

import load_stories from "./stories.ts";
site.data("load_stories", load_stories);

import sheets from "lume/plugins/sheets.ts";
site.use(sheets());

import sass from "lume/plugins/sass.ts";
site.use(sass());

import { groupBy } from "std/collections/group_by.ts";
import * as datetime from "std/datetime/mod.ts";
site.data("imports", { groupBy, datetime });

import inline from "lume/plugins/inline.ts";
site.use(inline({ extensions: [".html"], attribute: 'inline' }));

site.copy("static", "");
await site.build();
