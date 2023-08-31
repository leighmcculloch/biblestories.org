export default async function* (data) {
  const { imports, langs, t, load_stories } = data;

  const stories = await load_stories(data);

  const stories_grouped = Object.values(
    imports.groupBy(stories, ({ story_id }) => story_id),
  );

  for (const { lang } of langs) {
    yield {
      url: `/${lang}/api/stories.json`,
      content: JSON.stringify(
        {
          alternate: Object.fromEntries(
            langs.map((l) => [l.lang, `${l.base_url}/api/stories`]),
          ),
          data: Object.fromEntries(
            stories_grouped.map((s) => [
              s[0].story_id,
              {
                id: s[0].story_id,
                type: "story",
                title: t[lang].story.title[s[0].story_id],
                accounts: s.map((a) => ({
                  id: a.story_account_id,
                  type: "account",
                  title: t[lang].story.title[s[0].story_id],
                  bible_ref: a.langs[lang].ref,
                  bible_ref_english: a.langs[lang].ref_en,
                  author: a.langs[lang].author,
                  url: a.langs[lang].canonical_url,
                })),
              },
            ]),
          ),
        },
        null,
        2,
      ),
    };
  }
}
