require 'Avatax_TaxService'
require 'Avatax_AddressService'
require 'yaml'
#Note that the ping function exists in both the AddressSvc and TaxSvc classes - it works the same way in both.

#Create an instance of the service class
credentials = YAML::load(File.open('credentials.yml'))
svc = AvaTax::TaxService.new(:username => credentials['username'], 
      :password => credentials['password'],  
      :clientname => credentials['clientname'],
      :use_production_url => credentials['production']) 

  #Call the service
result = svc.ping
#print result

#Display the result
puts "Ping ResultCode: "+result[:result_code]

#If we encountered an error
if result[:result_code] != "Success"
  #Print the first error message returned
  puts result[:details]
end