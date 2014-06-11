class Web < Sinatra::Application

  before do
    I18n.locale = I18n.default_locale_for_host(request.host)
  end

  before "/" do
    unless I18n.path_for_locale.nil?
      redirect to(I18n.url_for_locale), 301
    end
  end

  before "/:locale/?*" do
    locale = params[:locale].to_sym
    path = params[:splat][0]

    if I18n.available_locales.include?(locale)
      if request.host != I18n.host_for_locale(locale: locale) || I18n.path_for_locale(locale: locale).nil?
        redirect to(I18n.url_for_locale(path: path, locale: locale)), 301
      else
        I18n.locale = locale
        request.path_info = "/#{path}"
      end
    end
  end

end