require 'Avatax_TaxService'
require 'date'
require 'yaml'

#Create an instance of the service class
credentials = YAML::load(File.open('credentials.yml'))
svc = AvaTax::TaxService.new(:username => credentials['username'], 
      :password => credentials['password'],  
      :clientname => credentials['clientname'],
      :use_production_url => credentials['production']) 
  #Create the request
  #Document Level Setup  
  #             R: indicates Required Element
  #             O: Indicates Optional Element
  #
  get_tax_request = {
    # Set the tax document properties - values are Required unless noted as Optional, but all properties must be defined.
    
    :companycode=>credentials['companycode'], # R: Company Code from the accounts Admin Console
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
    :locationcode=>"", # O: This is a reportable value that does not affect tax calculation.
    :commit=>"false", # O: Default is "false" - Set to "true" to commit the Document
      # TaxOverride    O: Allows the TaxDate (or other values) to be overridden for tax calculation. Situational only.  can be added at the document OR line level.
      #:taxoverridetype=>"TaxDate", 
      #:taxdate=>"1900-01-01", 
     # :reason=>"", 
    :currencycode=>"USD", # O: This is a reportable value that does not affect tax calculation.
    :servicemode=>"Remote", # O: This is a reportable value that does not affect tax calculation.
    :paymentdate=>"2013-09-26", # O: This is a reportable value that does not affect tax calculation.
    :exchangerate=>".0000", # O: This is a reportable value that does not affect tax calculation.
    :exchangerateeffdate=>"1900-01-01", # O: This is a reportable value that does not affect tax calculation.
    :poslanecode=>"", # O: This is a reportable value that does not affect tax calculation.
    :businessidentificationno=>"", # O: Specified VAT ID of customer for international/VAT calculations and reporting.
    :debug=>true,  # O: If true, transaction logs will be written in the gem root directory.    
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
      :latitude=>"", 
      :longitude=>""
      }, {
      :addresscode=>"456", 
      :line1=>"7070 West Arlington Drive", 
      :city=>"Lakewood", 
      :region=>"CO", 
      :postalcode=>"80123", 
      :country=>"US", 
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
      :taxincluded=>"false"
      }]} 
  
  #Call the service
result = svc.gettax(get_tax_request)
#Display the result
#puts result
puts "CalcTax ResultCode: "+result[:result_code]
#If we encountered an error
if result[:result_code] != "Success"
  result[:messages][:message].each do |message|
    puts message[:summary]+ ": " + message[:details]
  end
else
  puts "DocCode: " + result[:doc_code]+ " Total Tax Calculated: " + result[:total_tax]
  puts "Jurisdiction Breakdown:"
  #Show the tax amount calculated at each jurisdictional level
  result[:tax_lines][:tax_line].each do |line|
    puts "   "+  "Line Number " + line[:no] + ": Tax: " + line[:tax]
    #This will display the jurisdiction name and tax at each jurisdiction for the line.
    line[:tax_details][:tax_detail].each do |key,value| 
      puts "       " + key.to_s+ ": " + value.to_s
    end
  end
end
