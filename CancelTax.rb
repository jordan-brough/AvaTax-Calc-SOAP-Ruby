require 'Avatax_TaxService'
require 'yaml'

#Create an instance of the service class
credentials = YAML::load(File.open('credentials.yml'))
svc = AvaTax::TaxService.new(:username => credentials['username'], 
      :password => credentials['password'],  
      :clientname => credentials['clientname'],
      :use_production_url => credentials['production']) 
  
  #Create the request
  request = {
    :doccode=>"MyDocCode",   #Required
    :companycode=>credentials['companycode'],      #Required
    :doctype=>"SalesInvoice", #Required
    :cancelcode=>"DocVoided" #Required
    }
  #Call the service
result = svc.canceltax(request)
#Display the result
print "CancelTax ResultCode: "+result[:result_code]+"\n"

#If we encountered an error
if result[:result_code] != "Success"
  #Print the first error message returned
  print result[:details]+"\n"
end