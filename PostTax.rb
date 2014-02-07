require_relative 'Avatax_TaxService/lib/avatax_taxservice.rb'
require 'yaml'

#Create an instance of the service class
credentials = YAML::load(File.open('credentials.yml'))
svc = AvaTax::TaxService.new(:username => credentials['username'], 
      :password => credentials['password'],  
      :clientname => credentials['clientname'],
      :use_production_url => credentials['production']) 
  
  #Create the request
  request = {
    :docid=>"",   #optional
    :companycode=> credentials['companycode'],      #Required
    :doctype=>"SalesInvoice", #Required
    :doccode => "MyDocCode",
    :docdate => DateTime.now.strftime("%Y-%m-%d"),
    :totalamount => "1100.5500",
    :totaltax => "7",
    :hashcode => "0",
    :commit => "false",
    :newdoccode => "MyDocCode"    
    }
  #Call the service
result = svc.posttax(request)

#Display the result
print "PostTax ResultCode: "+result[:result_code]+"\n"

#If we encountered an error
if result[:result_code] != "Success"
  #Print the first error message returned
  print result[:messages][:message][0][:summary]+"\n"
end