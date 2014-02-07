require_relative 'Avatax_AddressService/lib/avatax_addressservice.rb'
require 'yaml'

#Create an instance of the service class
credentials = YAML::load(File.open('credentials.yml'))
svc = AvaTax::AddressService.new(:username => credentials['username'], 
      :password => credentials['password'],  
      :clientname => credentials['clientname'],
      :use_production_url => credentials['production']) 
  
  # Create the request
input = {
  :line1 => "General Delivery", #Required
  :line2 => "Suite 100",        #Optional
  :line3 => "Attn: Accounts Payable", #Optional
  :city =>"Seattle",            #Required, if PostalCode is not specified
  :region=>"WA",                #Required, if PostalCode is not specified
  :postalcode =>"98101",        #Required, if City and Region are not specified
  :country => "US"              #Optional
}
#Call the service
result = svc.validate(input)
#Display the result
#print result

#If we encountered an error
if result[:result_code] != "Success"
  #Print the first error message returned
  print "Address Validation ResultCode: "+result[:result_code]+"\n"
  print result[:details]+"\n"
else
  print "Validated Address: \n"
  result[:valid_addresses][:valid_address].each do |key, value|
    print key.to_s + ": " + value.to_s + "\n" if not value.nil?
  end
  
end
