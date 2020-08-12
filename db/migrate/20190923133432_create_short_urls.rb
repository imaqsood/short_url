class CreateShortUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :short_urls do |t|
      # You'll want to add some attributes here...

      t.timestamps
    end
  end
end
