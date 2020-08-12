class AddUrlDataToShortUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :short_urls, :title, :string
    add_column :short_urls, :full_url, :text
    add_column :short_urls, :short_code, :string
    add_column :short_urls, :click_count, :integer
  end
end
