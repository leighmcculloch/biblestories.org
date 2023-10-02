export default async function (data): any {
  const { dev, langs, t, stories_table } = data;
  const stories = [];

  for (const row of stories_table) {
    const s = Object.fromEntries(
      Object.keys(row).map((k) => [k, row[k].trim()]),
    );

    s.langs = {};
    for (const { lang } of langs) {
      s.langs[lang] = { lang };
    }

    for (const { lang } of langs) {
      s.langs[lang].passage_refs = s.ref.split(",").map((r) =>
        `${t[lang].bible_book[s.book]} ${r}`
      );
    }

    for (const { lang, bible, base_url } of langs) {
      const passages = await Promise.all(
        s.langs.en.passage_refs.map(async (ref: string) => ({
          ref,
          ...await (await fetch(
            `http://localhost:8080/?bible=${bible}&ref=${
              encodeURIComponent(ref)
            }`,
          )).json(),
        })),
      );

      const readingWordsPerMin = 220;
      const allText = passages.map((p) =>
        p.books.map((b) => b.lines.map((l) => l.verses.map((v) => v.text)))
      ).flat().join(" ");
      const wordCount = (allText.match(/ /g) || []).length;
      let duration = Math.round(wordCount / readingWordsPerMin);
      if (duration == 0) {
        duration = 1;
      }

      const url = `${t[lang].story.url[s.story_account_id]}`;
      const file_url = `/${lang}/${url}.html`;
      const canonical_url = `${base_url}/${url}${dev ? ".html" : ""}`;

      const ref = `${t[lang].bible_book[s.book]} ${s.ref}`;
      const ref_en = `${t.en.bible_book[s.book]} ${s.ref}`;

      const title = t[lang].story.title[s.story_id];

      s.langs[lang] = {
        ...s.langs[lang],
        base_url,
        url: file_url,
        canonical_url,
        browser_title: `${title} | ${t[lang].title}`,
        title,
        description: `${ref}. ${title}.`,
        ref,
        ref_en,
        passages,
        author: t[lang].bible_book_author[s.book],
        duration,
        copyright: { url: passages[0].url, text: passages[0].copyright },
        t: t[lang],
      };
    }

    stories.push(s);
  }

  for (const s of stories) {
    s.otherAccounts = stories.filter((o) =>
      s.story_id == o.story_id && s.story_account_id != o.story_account_id
    );
  }

  return stories;
}
