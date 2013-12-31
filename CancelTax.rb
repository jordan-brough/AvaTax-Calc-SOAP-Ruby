require_relative 'Avatax_TaxService/lib/avatax_taxservice.rb'

#Create an instance of the service class
svc = AvaTax::TaxService.new(
  :username => "account.admin.1100014690",  #TODO: Enter your username or account number here
  :password => "avalara",  #TODO: Enter your password or license key here
  :clientname => "AvaTaxCalcSOAP Ruby Sample"
  )
  
  #Create the request
  request = {
    :doccode=>"MyDocCode",   #Required
    :companycode=>"SDK",      #Required
    :doctype=>"SalesInvoice", #Required
    :cancelcode=>"DocVoided" #Required
    }
  #Call the service
result = svc.canceltax(request)
#Display the result
print "CancelTax ResultCode: "+result[:ResultCode][0]+"\n"

#If we encountered an error
if result[:ResultCode][0] != "Success"
  #Print the first error message returned
  print result[:Summary][0]+"\n"
end