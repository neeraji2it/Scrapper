require 'open-uri'

class Address < ActiveRecord::Base

  # validation
  validates :full_name, presence: true
  validates :full_address, presence: true



  # Because they are using post(new process) request with different url
  # I dicided to make another method for this
  def scrap_and_update_information_process_1
    base_url    = "http://www.pagesjaunes.fr/trouverlesprofessionnels/rechercheClassique.do"
    success = true

    response = HTTParty.post(base_url, query: { quoiqui: self.full_name, ou: self.full_address })
    data     = Nokogiri::HTML(response)


    results  = data.css("ol li.visitCard")

    unless results.blank? && results.count <= 0
      results.each do |result|
        id = result["id"]
        full_name     = scrap_full_name_1(data, id)
        full_address  = scrap_full_address_1(data, id)
        phone_number  = scrap_phone_number_1(data, id)

        unless full_name.blank? || full_address.blank? || phone_number.blank?
          address = Address.new(full_name: full_name, full_address: full_address, phone_number: phone_number)
          address.save!(validate: false)
        end
      end
    else
      success = false
    end
  end


  # The Day I started scrapping information from this site
  # It was using get request to fetch information
  # When I was done scrapping data, it was changed to POST request
  # and also they changed the layout completely
  def scrap_and_update_information_process_2
    base_url    = "http://www.pagesjaunes.fr/annuaire/chercherlespros?quoiqui=#{self.full_name}&ou=#{self.full_address}&idOu=''"
    success = true
    
    response  = HTTParty.get(base_url)
    data      = Nokogiri::HTML(response)

    result_container  = data.css("section#listResults.results")
    p result_container

    unless result_container.blank?
      articles = result_container.css("article.bi-bloc")

      if articles.count > 0
        articles.each do |article|
          id = article["id"]

          full_address  = scrap_full_address(data, id)
          full_name     = scrap_full_name(data, id)
          phone_number  = scrap_phone_number(data, id)

          unless full_name.blank? || full_address.blank? || phone_number.blank?
            address = Address.new(full_name: full_name, full_address: full_address, phone_number: phone_number)
            address.save!(validate: false)
          end
        end
      else
        success = false
      end
    else
      success = false
    end

    return success
  end


private

  def scrap_full_address(data, id)
    result        = data.css("article##{id} header.v-card .row .adresse-container a p span")
    full_address  = ""

    result.each do |res|
      full_address += res.text unless res.blank?
    end

    return full_address
  end

  def scrap_full_address_1(data, id)
    result = data.css("li##{id} .visitCardContent .dataCard .localisationBlock p")

    return result.text rescue nil
  end





  def scrap_full_name(data, id)
    result    = data.css("article##{id} div.description div.activites-cris span.donnees-insee span")

    name = result.map { |res| res.text }
    return name.join(" ")
  end

  def scrap_full_name_1(data, id)
    result = data.css("li##{id} .visitCardContent h2.titleMain a.companyName span")

    p result.text rescue nil

    return result.first.text rescue nil
  end




  def scrap_phone_number(data, id)
    result = data.css("article##{id} footer.bi-contact li.item strong")
    phone = ""

    if result.present?
      if result.is_a?(Array)
        phones = result.map { |ph| ph.text }
        phone = phones.join(", ")
      else
        phone = result.text
      end
    end

    return phone
  end

  def scrap_phone_number_1(data, id)
    result = data.css("li##{id} .visitCardContent .dataCard .contactBlock  ul.blocPhoneNumber li.hideTel")
    result = result.blank? ? "" : result.text.gsub("\n", "").gsub("  ", "")
    return result.split(":").join(" : ")
  end
end


# Translation
# 1. annuaire -> Phone Book
# 2. chercher -> look for
# 3. les      -> the
# 4. ou       -> OR
# 5. quoi qui => watch Who
