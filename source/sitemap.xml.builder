# Simplified from: https://gist.github.com/tommysundstrom/5756032

xml.instruct!

xml.urlset(
  "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9",
  "xmlns:xhtml" => "http://www.w3.org/1999/xhtml"
) do

  # home page
  xml.url do
    xml.loc(settings.deployment.base_url)
    xml.lastmod(Time.now.strftime("%Y-%m-%d"))
    settings.deployments.locales.each do |locale|
      xml.xhtml(:link, :rel=>"alternate", :hreflang=>locale, :href=>settings.deployments.base_url(locale: locale))
    end
  end

  # stories
  Stories.all_accounts.each do |story_id, story|
    xml.url do
      xml.loc("#{settings.deployment.base_url}/#{story.short_url}")
      xml.lastmod(Time.now.strftime("%Y-%m-%d"))
      settings.deployments.locales.each do |locale|
        xml.xhtml(:link, :rel=>"alternate", :hreflang=>locale, :href=>"#{settings.deployments.base_url(locale: locale)}/#{story.short_url(locale: locale)}")
      end
    end
  end
end
