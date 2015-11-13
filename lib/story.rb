class Story
  attr_reader :id, :accounts

  def initialize(id, accounts = [])
    @id = id
    @accounts = accounts
  end

  def title
    I18n.t("story.title.#{id}")
  end

  def default_account
    @accounts.first
  end

  def as_json(options)
    {
      :id => self.id,
      :type => self.class.name.downcase,
      :title => self.title,
      :accounts => self.accounts.map { |account| account.as_json(options) }
    }
  end
end

