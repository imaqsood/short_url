class ShortUrl < ApplicationRecord
  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
  DEFAULT_ATTR = %i[title full_url short_code click_count].freeze

  validates \
    :full_url,
    format: {
      with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
      on: :create,
      message: 'is not a valid url'
    },
    presence: true

  after_save :update_short_code

  def short_code
    generate_short_code_for(id) unless new_record?
  end

  def update_title!
    update_column :title, full_url_title
  end

  def click_count
    super || 0
  end

  def as_json(options = {})
    options = { only: DEFAULT_ATTR } unless options.key?(:only)
    super options
  end

  def self.charactors_count
    @charactors_count ||= CHARACTERS.count
  end

  private

  def update_short_code
    generate_short_code_for(id) if short_code.blank? || id_previously_changed?
  end

  def update_short_code!(code)
    update_column(:short_code, code) unless self[:short_code] == code
  end

  def full_url_title
    Nokogiri::HTML(full_url_response).css('title').text
  end

  def full_url_response
    Net::HTTP.get(URI.parse(full_url))
  end

  def generate_short_code_for(number)
    count = self.class.charactors_count
    short_code = CHARACTERS[number % count].dup
    short_code.prepend(CHARACTERS[number % count]) until (number /= count).zero?
    update_short_code!(short_code)
    short_code
  end
end
