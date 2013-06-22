require "api2pdf/version"
require 'httparty'
require 'active_support'
require 'prawn'

class API2PDF
  class << self

    def titlize(pdf, text)
      pdf.text "<u>#{ActiveSupport::Inflector.humanize(text).upcase}</u>:", style: :bold, size: 8, :inline_format => true
    end

    def pdf_body_print(pdf, obj)
      # FIELD VALUE CAN BE A STRING, HASH, ARRAY OF STRING, HASH, ETC
      case obj.class.to_s
      when "Array"
        obj.each_with_index { |ele, index| pdf_body_print(pdf, ele) }
      when "Hash"
        obj.each do |key, value|
          case value.class.to_s
          when "Array"
            pdf.pad_bottom(5) { pdf.pad_bottom(3) {titlize(pdf, key)}; pdf.indent(20) {pdf_body_print(pdf, value)}; }
          when "Hash"
            titlize(pdf, key)
            pdf.indent(20) { value.each { |key, value| pdf.pad_bottom(5) {titlize(pdf, key); pdf_body_print(pdf, value);} } }
          when "String"
            pdf.pad_bottom(5) { titlize(pdf, key); pdf.indent(20) {pdf.text "#{value}", size: 10, align: :justify}; }
          end
        end
      else
        pdf.text "#{obj.to_s}", size: 10, align: :justify
      end
    end

    def export(arg_hash)
      default_param = {
        :heading        => nil,
        :file_name      => "#{Time.now}",
        :page_layout    => :portrait,
        :page_size      => "LETTER",
        :columns        => 1
      }
      arg_hash = default_param.merge(arg_hash)
      @safe_file_name = "#{arg_hash[:file_name].gsub(/[^0-9A-Za-z.\-]/, '_').gsub('.','')}.pdf"

      @fetch = HTTParty.get("#{arg_hash[:url]}")
      Prawn::Document.generate(@safe_file_name, arg_hash) do |pdf|
        # PDF headings
        if (!arg_hash[:heading].nil?)
          pdf.pad_bottom(20) { pdf.text "#{arg_hash[:heading]}", size: 20, align: :center, style: :bold }
        end
        # PDF body
        pdf.column_box([0, pdf.cursor], :columns => arg_hash[:columns], :width => pdf.bounds.width) do
          @fetch.each do |key, value|
            if (!value.nil?)
              pdf.pad_bottom(5) { titlize(pdf, key) }
              pdf.indent(20) { pdf_body_print(pdf, value) }
            end
          end
        end
      end
    end # END: export(arg_hash)

  end # END: class << self
end