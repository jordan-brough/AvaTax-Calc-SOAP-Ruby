require 'Avatax_TaxService'

#Create an instance of the service class
svc = AvaTax::TaxService.new(
  :username => "",  #TODO: Enter your username or account number here
  :password => "",  #TODO: Enter your password or license key here
  :clientname => "AvaTaxCalcSOAP Ruby Sample"
  )

  #Call the service
result = svc.ping

#Display the result
print "Ping ResultCode: "+result[:ResultCode][0]+"\n"

#If we encountered an error
if result[:ResultCode][0] != "Success"
  #Print the first error message returned
  print result[:Summary][0]+"\n"
end