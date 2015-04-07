require 'open-uri'

class Address < ActiveRecord::Base
  include Concerns::FirstScrapper
  include Concerns::SecondScrapper

  # validation
  validates :full_name, presence: true
  validates :full_address, presence: true


  def self.to_csv
    CSV.generate do |csv|
      columns = ["full_name", "full_address", "phone_number"]
      csv << columns

      all.each do |address|
        csv << address.attributes.values_at(*columns)
      end
    end
  end
end


# Translation
# 1. annuaire -> Phone Book
# 2. chercher -> look for
# 3. les      -> the
# 4. ou       -> OR
# 5. quoi qui => watch Who
