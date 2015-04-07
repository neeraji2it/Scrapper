module Concerns::FirstScrapper
  extend ActiveSupport::Concern

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

        unless full_name.blank? && full_address.blank? && phone_number.blank?
          address = Address.new(full_name: full_name, full_address: full_address, phone_number: phone_number)
          address.save!(validate: false)
        end
      end
    else
      success = false
    end
  end

  def scrap_full_address_1(data, id)
    result = data.css("li##{id} .visitCardContent .dataCard .localisationBlock p")

    return result.text rescue nil
  end


  def scrap_full_name_1(data, id)
    result = data.css("li##{id} .visitCardContent h2.titleMain a.companyName span")

    return result.first.text rescue nil
  end


  def scrap_phone_number_1(data, id)
    skip_text = "Signification des pictogrammes."
    skip_text2 = "Signification des pictogrammes"

    result = data.css("li##{id} .visitCardContent .dataCard .contactBlock  ul.blocPhoneNumber li.hideTel")
    result = result.first.css("strong").text rescue nil

    return result.gsub(skip_text, "").gsub(skip_text2, "")
  end
end