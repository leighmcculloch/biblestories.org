export const layout = "./_index.njk";

export default async function* (data) {
  const { imports, langs, t, load_stories } = data;

  const stories = await load_stories(data);

  const stories_grouped = Object.values(
    imports.groupBy(stories, ({ story_id }) => story_id),
  );

  for (const { lang, base_url } of langs) {
    const file_url = `/${lang}/`;
    const canonical_url = `${base_url}`;
    yield {
      base_url,
      langs: Object.fromEntries(langs.map((l) => [
        l.lang,
        {
          ...l,
          t: t[l.lang],
          canonical_url: `${l.base_url}`,
        },
      ])),
      lang,
      t: t[lang],
      url: file_url,
      canonical_url,
      title: t[lang].title,
      description: t[lang].meta_description,
      stories: stories_grouped,
    };
  }
}
