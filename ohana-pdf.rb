# ---------------------------------------------------------------------------------
# A TAILORED VERSION TO OHANA API
# ---------------------------------------------------------------------------------
# Call:
# API2PDF.export(
#   url: "http://ohanapi.herokuapp.com/api/organizations/51a9fd0628217f89770003ab",
#   h1: "Code for America: Human Services Finder",
#   h2: "name"
# )
# ---------------------------------------------------------------------------------

require 'httparty'
require 'active_support'
require 'prawn'

class API2PDF
  class << self
    def pdf_body_print(obj)
      output = ""
      # Field value can be a string, hash, array of string, hash, etc
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

    def export(arg_hash)
      @fetch = HTTParty.get("#{arg_hash[:url]}")
      # Strip out non-ascii characters and stops
      @safe_file_name = @fetch["response"]["name"].gsub(/[^0-9A-Za-z.\-]/, '_').gsub('.','') || @fetch["response"]["_id"]
      Prawn::Document.generate("#{@safe_file_name}.pdf", page_layout: :landscape, ) do |pdf|
        # PDF headings
        pdf.pad_bottom(20) { 
          pdf.text "#{arg_hash[:h1]}", size: 20, align: :center, style: :bold
          pdf.text "#{@fetch["response"]["#{arg_hash[:h2]}"] || @fetch["response"]["_id"]}", size: 14, align: :center, style: :bold
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
    end # END: export(arg_hash)

  end # END: class << self
end