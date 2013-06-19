# ------------------------------------------------
# Call: ruby ohana-pdf.rb ORGANIZATION_ID
# i.e : ruby ohana-pdf.rb 51a9fd0328217f89770001b2
# ------------------------------------------------

require 'httparty'
require 'active_support'
require 'prawn'

API_URL = "http://ohanapi.herokuapp.com/api/organizations/"

def pdf_body_print(obj)
  output = ""

  # FIELD VALUE CAN BE A STRING, A HASH, AN ARRAY 
  # OF STRING, HASH, OR OF ANOTHER ARRAY. 
  if obj.class == Array
    obj.each_with_index do |ele, index|
      output << pdf_body_print(ele)
      output << ", " if (index != obj.length-1)
    end
  elsif obj.class == Hash
    obj.each_with_index do |(key, value), index|
      if value.class == Array
        output << "#{ActiveSupport::Inflector.humanize(key)}: "
        output << pdf_body_print(value)
      else
        output << "#{ActiveSupport::Inflector.humanize(key)}: #{value}"
      end
      output << ", " if (index != obj.length-1)
    end
  else
    output << obj.to_s
  end

  return output
end

# ------------------------------------------------
# ---------------------- MAIN --------------------
# ------------------------------------------------

# FETCH JSON
@fetch = HTTParty.get("#{API_URL}#{ARGV[0]}")

# GENERATE PDF
# Strip out non-ascii characters and stops
@safe_file_name = @fetch["response"]["name"].gsub(/[^0-9A-Za-z.\-]/, '_').gsub('.','') || ARGV[0]
Prawn::Document.generate("#{@safe_file_name}.pdf", page_layout: :landscape, ) do |pdf|

  # PDF headings
  pdf.pad_bottom(20) { 
    pdf.text "Code for America: Human Services Finder", size: 20, align: :center, style: :bold
    pdf.text "#{@fetch["response"]["name"] || ARGV[0]}", size: 14, align: :center, style: :bold
  }

  # PDF body
  pdf.column_box([0, pdf.cursor], :columns => 2, :width => pdf.bounds.width) do
    @fetch["response"].each do |key, value|
      if (!value.nil? && key != "_id")
        pdf.pad_bottom(5) { pdf.text "#{ActiveSupport::Inflector.humanize(key).upcase}:", 
          style: :bold, size: 9 }
        pdf.pad_bottom(15) { pdf.text pdf_body_print(value), size: 10, align: :justify }
      end
    end
  end
end