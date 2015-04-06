class Address < ActiveRecord::Base

  # validation
  validates :full_name, presence: true
  validates :full_address, presence: true

  def scrap_and_update_information
    base_url    = "http://www.pagesjaunes.fr/annuaire/chercherlespros?quoiqui=#{self.full_name}&ou=#{self.full_address}"
        
  end
end


# Translation
# 1. annuaire -> Phone Book
# 2. chercher -> look for
# 3. les      -> the
# 4. ou       -> OR
# 5. quoi qui => watch Who
