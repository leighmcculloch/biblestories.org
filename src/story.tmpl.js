export const layout = "./_story.njk";

export default async function* (data) {
  const { langs, load_stories } = data;

  const stories = await load_stories(data);

  for (const s of stories) {
    for (const { lang } of langs) {
      yield {
        ...s,
        ...s.langs[lang],
      };
    }
  }
}
