require 'Avatax_AddressService'

#Create an instance of the service class
svc = AvaTax::AddressService.new(
  :username => "",  #TODO: Enter your username or account number here
  :password => "",  #TODO: Enter your password or license key here
  :clientname => "AvaTaxCalcSOAP Ruby Sample"
  )
  
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

#If we encountered an error
if result[:ResultCode] != "Success"
  #Print the first error message returned
  print "Address Validation ResultCode: "+result[:ResultCode]+"\n"
  print result[:Summary]+"\n"
else
  print "Validated Address: \n"
  result.each do |key, value|
    print key.to_s + ": " + value +"\n"
  end
  
end
