export const layout = './_404.njk';

export default async function* ({ langs, t }) {
    for (const { lang, base_url } of langs) {
        const url = `404.html`;
        const file_url = `/${lang}/${url}`;
        const canonical_url = `${base_url}/${url}`;
        yield {
            base_url,
            langs: langs.map(l => ({
                ...l,
                t: t[l.lang],
                canonical_url: `${l.base_url}/${url}`
            })),
            lang,
            t: t[lang],
            url: file_url,
            canonical_url,
            title: t[lang].page_not_found,
            description: '',
        };
    }
}
