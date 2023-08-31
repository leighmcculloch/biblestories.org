export default async function* (data) {
  const { imports, langs, load_stories } = data;

  const stories = await load_stories(data);

  const lastmod = imports.datetime.format(new Date(), "yyyy-MM-dd");

  for (const { lang, base_url } of langs) {
    const urls = [
      {
        loc: base_url,
        lastmod,
        links: langs.map((l) => ({
          hreflang: l.lang,
          href: l.base_url,
        })),
      },
    ].concat(stories.map((s) => ({
      loc: s.langs[lang].canonical_url,
      lastmod,
      links: Object.entries(s.langs).map(([_, l]) => ({
        hreflang: l.lang,
        href: l.canonical_url,
      })),
    })));
    yield {
      url: `/${lang}/sitemap.xml`,
      content: `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">${
        urls.map((url) => `
  <url>
    <loc>${url.loc}</loc>
    <lastmod>${url.lastmod}</lastmod>
    ${
          url.links.map((link) =>
            `<xhtml:link rel="alternate" hreflang="${link.hreflang}" href="${link.href}" />`
          ).join(
            "",
          )
        }
  </url>
      `).join("")
      }
</urlset>`,
    };
  }
}
