# ------------------------------------------------
# [DONE] STAGE 1: FETCH JSON AND OUTPUT ON COMMAND LINE
# [DONE] STAGE 2: GENERATE PDF FILE
# STAGE 3: FORMAT OUTPUTTED PDF
# ------------------------------------------------
# Call: ruby ohana-pdf.rb ORGANIZATION_ID
# i.e : ruby ohana-pdf.rb 51a9fd0328217f89770001b2
# ------------------------------------------------
# TODOS
# Set CONSTANT for API URL
# Remove special character from PDF filename
# ------------------------------------------------

require 'httparty'
require 'active_support'
require 'prawn'

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
      output << "#{ActiveSupport::Inflector.humanize(key).upcase}: #{value}"
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
@fetch = HTTParty.get("http://ohanapi.herokuapp.com/api/organizations/#{ARGV[0]}")

# GENERATE PDF
Prawn::Document.generate("#{@fetch["response"]["name"] || ARGV[0]}.pdf") do |pdf|

  # PDF headings
  pdf.pad(20) { 
    pdf.text "Code for America: Human Services Finder", size: 20, align: :center, style: :bold
    pdf.text "#{@fetch["response"]["name"] || ARGV[0]}", size: 14, align: :center, style: :bold
  }

  # PDF body
  @fetch["response"].each do |key, value|
    if (!value.nil? && key != "_id")
      pdf.pad_bottom(5) { pdf.text "#{ActiveSupport::Inflector.humanize(key).upcase}:", 
        style: :bold, size: 9 }
      pdf.pad_bottom(20) { pdf.text pdf_body_print(value), size: 10, align: :justify }
    end
  end
end