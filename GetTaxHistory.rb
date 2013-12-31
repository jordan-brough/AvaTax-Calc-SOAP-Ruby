require 'Avatax_TaxService'

#Create an instance of the service class
svc = AvaTax::TaxService.new(
  :username => "",  #TODO: Enter your username or account number here
  :password => "",  #TODO: Enter your password or license key here
  :clientname => "AvaTaxCalcSOAP Ruby Sample"
  )
  
  #Create the request
  request = {
    :doccode=>"MyDocCode",    #Required
    :companycode=>"SDK",      #Required
    :doctype=>"SalesInvoice", #Required
    :docid=> "",              #Optional
    :detaillevel=>"Tax",      #Optional
    :debug => false           #Optional
    }
  #Call the service
result = svc.gettaxhistory(request)
print result
#Display the result
print "GetTaxHistory ResultCode: "+result[:ResultCode][0]+"\n"
#If we encountered an error
if result[:ResultCode][0] != "Success"
  print result[:Summary][0] +"\n"
else
  print "DocCode: " + result[:GetTaxResultDocCode][0]+ " Total Tax Calculated: " + result[:GetTaxResultTotalTax][0].to_s + "\n"
  print "Jurisdiction Breakdown:\n"
  #Show the tax amount calculated at each jurisdictional level
  #The result object collapses each element of the tax details into a single array, so some additional work is required to detangle them.
  (0...result[:GetTaxResultNo].length).each do |lineIndex|
    print "   "
    print "Line Number " + result[:GetTaxResultNo][lineIndex] + ":"
    print "\n"
    #This will display the jurisdiction name and tax at each jurisdiction for the line.
    numDetails = result[:GetTaxResultTaxDetailJurisName].length / result[:GetTaxResultNo].length
    ((lineIndex * numDetails)...((lineIndex + 1) * numDetails)).each do |detailIndex| 
      print "       "
      print result[:GetTaxResultTaxDetailJurisName][detailIndex]+ ": " +result[:GetTaxResultTaxDetailTax][detailIndex]
      print "\n"
    end
  end
end