require 'Avatax_TaxService'
require 'date'

#Create an instance of the service class
svc = AvaTax::TaxService.new(
  :username => "",  #TODO: Enter your username or account number here
  :password => "",  #TODO: Enter your password or license key here
  :clientname => "AvaTaxCalcSOAP Ruby Sample"
  )
  #Create the request
  #Document Level Setup  
  #             R: indicates Required Element
  #             O: Indicates Optional Element
  #
  get_tax_request = {
    # Set the tax document properties - values are Required unless noted as Optional, but all properties must be defined.
    
    :companycode=>"SDK", # R: Company Code from the accounts Admin Console
    :doctype=>"SalesInvoice", # R: Typically SalesOrder,SalesInvoice, ReturnInvoice
    :doccode=>"SampleDoc: " + DateTime.now.to_s, # R: Invoice or document tracking number - Must be unique
    :docdate=>DateTime.now.strftime("%Y-%m-%d"), # R: Sets reporting date and default tax date
    :salespersoncode=>"Bill Sales", # O: This is a reportable value that does not affect tax calculation.
    :customercode=>"TaxSvcTestCust", # R: String - Customer Tracking number or Exemption Customer Code
    :customerusagetype=>"", # O: Send for tax exempt transactions only.
    :discount=>".0000", # O: Send for document-level discounts only.
    :purchaseorderno=>"PO123456", # O: Specifies the purchase order number associated with the transaction. This value can be used to track single-use exemption certficates.
    :exemptionno=>"",  # O: Send for tax exempt transactions only.
    :origincode=>"123", # R: Value representing the Origin Address
    :destinationcode=>"456", # R: Value representing the Destination Address
    :detaillevel=>"Tax", # R: Chose Summary, Document, Line or Tax - varying levels of results detail 
    :referencecode=>"", # O: This is a reportable value that does not affect tax calculation.
    :hashcode=>"0", # O: This must be 0
    :locationcode=>"", # O: This is a reportable value that does not affect tax calculation.
    :commit=>"false", # O: Default is "false" - Set to "true" to commit the Document
    :batchcode=>"", # O: This must be left blank.
      # TaxOverride    O: Allows the TaxDate (or other values) to be overridden for tax calculation. Situational only. 
      :taxoverridetype=>"None", 
      :taxamount=>".0000", 
      :taxdate=>"1900-01-01", 
      :reason=>"", 
    :currencycode=>"USD", # O: This is a reportable value that does not affect tax calculation.
    :servicemode=>"Remote", # O: This is a reportable value that does not affect tax calculation.
    :paymentdate=>"2013-09-26", # O: This is a reportable value that does not affect tax calculation.
    :exchangerate=>".0000", # O: This is a reportable value that does not affect tax calculation.
    :exchangerateeffdate=>"1900-01-01", # O: This is a reportable value that does not affect tax calculation.
    :poslanecode=>"", # O: This is a reportable value that does not affect tax calculation.
    :businessidentificationno=>"", # O: Specified VAT ID of customer for international/VAT calculations and reporting.
    :debug=>true,  # O: If true, transaction logs will be written in the gem root directory.
    :validate=>false,  # O: If true, tax address information may be returned by the service.
    
    #   Address Section
    #   Add the origin and destination addresses referred to by the
    #   "OriginCode" and "DestinationCode" properties above.
    :addresses=>[{
      :addresscode=>"123", 
      :line1=>"100 ravine lane", 
      :line2=>"Suite 21", 
      :city=>"Bainbridge Island", 
      :region=>"WA", 
      :postalcode=>"98110", 
      :country=>"US", 
      :taxregionid=>"0", 
      :latitude=>"", 
      :longitude=>""
      }, {
      :addresscode=>"456", 
      :line1=>"7070 West Arlington Drive", 
      :city=>"Lakewood", 
      :region=>"CO", 
      :postalcode=>"80123", 
      :country=>"US", 
      :taxregionid=>"0"
      }], 
    
    # Add invoice lines
    :lines=>[{
      :no=>"1", # R: string - line Number of invoice - must be unique within the document.
      :itemcode=>"Canoe",  #R: string - SKU or short name of Item
      :qty=>"1", # R: decimal - The number of items -- Qty of product sold.
      :amount=>"300.43", # R: decimal - the "NET" amount -- Amount should be the 'extended' or 'net' amount
      :discounted=>"false", # R: determines if the document-level discount should be applied to this line item.
      :ref1=>"ref1", # O: This is a reportable value that does not affect tax calculation.
      :ref2=>"ref2", # O: This is a reportable value that does not affect tax calculation.
      :description=>"Blue canoe", # O: string - Description or category of item sold.
            # TaxOverride    O: Allows the TaxDate (or other values) to be overridden for tax calculation. Situational only.
        :taxoverridetypeline=>"TaxAmount", 
        :taxamountline=>"10", 
        :taxdateline=>"1900-01-01", 
        :reasonline=>"Tax credit", 
      :taxincluded=>"false" # O: Determines if the line amount on the request includes the tax amount
      }, {
      :no=>"2", 
      :itemcode=>"Rowing boat", 
      :qty=>"1", 
      :amount=>"800.12", 
      :discounted=>"false", 
      :ref1=>"ref3", 
      :ref2=>"ref4", 
      :description=>"Red rowing boat", 
      :taxoverridetypeline=>"None", 
      :taxamountline=>"0", 
      :taxdateline=>"1900-01-01", 
      :taxincluded=>"false"
      }]} 
  
  #Call the service
result = svc.gettax(get_tax_request)
#Display the result

#If we encountered an error
if result[:ResultCode][0] != "Success"
  #Print a message - the gem does not decode the error from the service.
  print "An error was encountered \n"
else
  print "CalcTax ResultCode: "+result[:ResultCode][0]+"\n"
  print "DocCode: " + result[:GetTaxResultDocCode][0]+ " Total Tax Calculated: " + result[:GetTaxResultTotalTax][0].to_s + "\n"
  print "Jurisdiction Breakdown:\n"
  #Show the tax amount calculated at each jurisdictional level
  #The result object collapses each element of the tax details into a single array, so some additional work is required to detangle them.
  (0...result[:TaxLineNo].length).each do |lineIndex|
    print "   "
    print "Line Number " + result[:TaxLineNo][lineIndex] + ": Tax: " + result[:TaxLineTax][lineIndex]
    print "\n"
    #This will display the jurisdiction name and tax at each jurisdiction for the line.
    numDetails = result[:TaxDetailJurisName].length / result[:TaxLineNo].length
    ((lineIndex * numDetails)...((lineIndex + 1) * numDetails)).each do |detailIndex| 
      print "       "
      print result[:TaxDetailJurisName][detailIndex]+ ": " +result[:TaxDetailTax][detailIndex]
      print "\n"
    end
  end
end
