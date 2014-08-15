require 'Avatax_TaxService'
require 'yaml'

credentials = YAML::load(File.open('credentials.yml'))

# Header Level Parameters
taxSvc = AvaTax::TaxService.new(

# Required Header Parameters
  :username => credentials['account_number'], 
  :password => credentials['license_key'],  
  :use_production_url => credentials['use_production_url'],
  :clientname => "AvaTaxSample",

# Optional Header Parameters  
  :name => "Development") 

pingResult = taxSvc.ping

#Display the result
puts "PingTest ResultCode: " + pingResult[:result_code]
if pingResult[:result_code] != "Success"
  pingResult[:messages].each { |message| puts message[:details] }
end