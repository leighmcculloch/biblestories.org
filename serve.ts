import "./build.ts";

import { serveDir } from "std/http/file_server.ts";
Deno.serve((req: Request) => {
  return serveDir(req, {
    fsRoot: "./_site",
  });
});
