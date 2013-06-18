# ------------------------------------------------
# STAGE 1: FETCH JSON AND OUTPUT ON COMMAND LINE
# ------------------------------------------------
# Call: ruby ohana_pdf.rb ORGANIZATION_ID
# i.e : ruby ohana_pdf.rb 51a9fd0628217f89770003ab
# ------------------------------------------------
# TODOS
# Inflector.humanize ignores _keys, i.e: _id
# ------------------------------------------------

require 'httparty'
require 'active_support'

def sprint(obj)
  if obj.class == Array
    obj.each_with_index do |ele, index|
      sprint(ele)
      printf ", " if (index != obj.length-1)
    end
  elsif obj.class == Hash
    obj.each_with_index do |(key, value), index|
      printf "#{ActiveSupport::Inflector.humanize(key).upcase}: #{value}"
      printf ", " if (index != obj.length-1)
    end
  else
    printf obj.to_s
  end
end

@fetch = HTTParty.get("http://ohanapi.herokuapp.com/api/organizations/#{ARGV[0]}")
@fetch["response"].each do |key, value|
  unless value.nil?
    printf("%40s", "#{ActiveSupport::Inflector.humanize(key).upcase} >> ")
    sprint(value)
    puts ""
  end
end