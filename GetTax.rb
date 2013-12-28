require 'Avatax_TaxService'
require 'date'

#Create an instance of the service class
svc = AvaTax::TaxService.new(
  :username => "",  #TODO: Enter your username or account number here
  :password => "",  #TODO: Enter your password or license key here
  :clientname => "AvaTaxCalcSOAP Ruby Sample"
  )
  document = {:companycode=>"SDK", :doctype=>"SalesInvoice", :doccode=>"MyDocCode", :docdate=>"2013-10-11", :salespersoncode=>"Bill Sales", :customercode=>"CUS001", :customerusagetype=>"", :discount=>".0000", :purchaseorderno=>"PO123456", :exemptionno=>"", :origincode=>"123", :destinationcode=>"456", :addresses=>[{:addresscode=>"123", :line1=>"100 ravine lane", :line2=>"Suite 21", :city=>"Bainbridge Island", :region=>"WA", :postalcode=>"98110", :country=>"US", :taxregionid=>"0", :latitude=>"", :longitude=>""}, {:addresscode=>"456", :line1=>"7070 West Arlington Drive", :city=>"Lakewood", :region=>"CO", :postalcode=>"80123", :country=>"US", :taxregionid=>"0"}], :lines=>[{:no=>"1", :itemcode=>"Canoe", :qty=>"1", :amount=>"300.43", :discounted=>"false", :ref1=>"ref1", :ref2=>"ref2", :description=>"Blue canoe", :taxoverridetypeline=>"TaxAmount", :taxamountline=>"10", :taxdateline=>"1900-01-01", :reasonline=>"Tax credit", :taxincluded=>"false"}, {:no=>"2", :itemcode=>"Rowing boat", :qty=>"1", :amount=>"800.12", :discounted=>"false", :ref1=>"ref3", :ref2=>"ref4", :description=>"Red rowing boat", :taxoverridetypeline=>"None", :taxamountline=>"0", :taxdateline=>"1900-01-01", :taxincluded=>"false"}], :detaillevel=>"Tax", :referencecode=>"", :hashcode=>"0", :locationcode=>"", :commit=>"false", :batchcode=>"", :taxoverridetype=>"None", :taxamount=>".0000", :taxdate=>"1900-01-01", :reason=>"", :currencycode=>"USD", :servicemode=>"Remote", :paymentdate=>"2013-09-26", :exchangerate=>".0000", :exchangerateeffdate=>"1900-01-01", :poslanecode=>"", :businessidentificationno=>"", :debug=>true, :validate=>false} 
  #Create the request
  #Document Level Setup  
  #             R: indicates Required Element
  #             O: Indicates Optional Element
  #
  calc_tax_request = {
      # Set the tax document properties - Required unless noted as Optional
      :companycode => "SDK",                          # R: Company Code from the accounts Admin Console
      :doccode =>"SampleDoc: " + DateTime.now.to_s,   # R: Invoice or document tracking number - Must be unique
      :doctype => "SalesInvoice",                     # R: Typically SalesOrder,SalesInvoice, ReturnInvoice
      :docdate => DateTime.now.strftime("%Y-%m-%d"),  # R: Sets reporting date and default tax date
      :customercode => "TaxSvcTest",                  # R: String - Customer Tracking number or Exemption Customer Code
      :detaillevel => "Tax",                          # R: Chose Summary, Document, Line or Tax - varying levels of results detail 
      :commit => "false",                               # O: Default is "false" - Set to "true" to commit the Document
      #:customerusagetype => "G",                     # O: Send for tax exempt transactions only.
      #:exemptionno => "12334",                       # O: Send for tax exempt transactions only.
      #:discount => 0,                                # O: Send for document-level discounts only.
      :purchaseorderno => "PO 23423",                 # O: Specifies the purchase order number associated with the transaction. This value can be used to track single-use exemption certficates.
      :referencecode => "",                           # O: This is a reportable value that does not affect tax calculation.
      :poslanecode => "",                             # O: This is a reportable value that does not affect tax calculation.
      :salespersoncode => "Bill Sales",               # O: This is a reportable value that does not affect tax calculation.
      # TaxOverride                                     O: Allows the TaxDate (or other values) to be overridden for tax calculation. Situational only.    
      #   :taxoverridetype => "TaxDate",
      #   :reason => "Credit Memo",
      #   :taxdate => "2011-07-13",
      #   :taxamount => 0
      #}]                                        
      #:businessidentificationno => "",               # O: Specified VAT ID of customer for international/VAT calculations and reporting.
              
              
  #                  Begin Address Section
  #                  Add the origin and destination addresses referred to by the
  #                  "setOriginCode" and "setDestinationCode" properties above.

      :addresses => [{
        :addresscode => "Origin",
        :line1 => "Avalara",
        :line2 => "100 Ravine Lane NE",
        :line3 => "Suite 220",
        :city => "Bainbridge Island",
        :region => "WA",
        :postalcode => "98110",
        :country => "US"
        },
        {
        :addresscode => "Dest",
        :line1 => "7462 Kearny Street",
        :city => "Commerce City",
        :region => "CO",
        :postalcode => "80022",
        :country => "US"    
        }],

    #
    # Alternate:  Latitude / Longitude addressing
    #                                   
    #   :addresses => [{
    #   :addressCode => "Origin",
    #   :latitude => "47.6253",
    #   :longitude => "-122.515114",
    #    },{
    #    :addressCode => "Destination",
    #    :latitude => "39.833597",
    #    :longitude => "-104.917220"
    #    }],                  

  # End Address Section

      # Add invoice lines
  
      :lines => [{                             
      :no => "101",                                   # R: string - line Number of invoice - must be unique.
      :itemcode => "Item001",                         # R: string - SKU or short name of Item
      :qty => 1,                                      # R: decimal - The number of items -- Qty of product sold.
      :amount => 1000.00,                             # R: decimal - the "NET" amount -- Amount should be the 'extended' or 'net' amount
      #:CustomerUsageType => "G",                     # O: string - AKA Entity Use Code - Typically A - L 
      :description => "ITEM1",                        # O: string - Description or category of item sold.
      :taxcode => "",                                 # O: string - Pass standard, custom or Pro-Tax code
                                                      #             Can be NULL to default to tangible personal property =P0000000)
      :origincode => "Origin",                        # R: Value representing the Origin Address
      :destinationcode => "Dest",                     # R: Value representing the Destination Address
      },{
      #Line 2 - Shipping/Freight line - See property descriptions above
      :no => "102",                                   # R: string - SKU or short name of Item
      :itemcode => "Shipping",                        # R: string - SKU or short name of Item
      :description => "Shipping- Freight Charges",    # O: string - Description or category of item sold.
      :qty => 1,                                      # R: decimal - The number of items -- Qty of product sold. Does not function as a mulitplier for Amount
      :amount => 10.00,                               # R: decimal - the "NET" amount -- Amount should be the 'extended' or 'net' amount
      :taxcode => "FR",                               # O: string - Pass standard, custom or Pro-Tax code FR020100
      :origincode => "Origin",                        # R: Value representing the Origin Address
      :destinationcode => "Dest",                     # R: Value representing the Destination Address
      }]
    }
  #Call the service
result = svc.gettax(document)
print result
#Display the result
print "CalcTax ResultCode: "+result[:ResultCode][0]+"\n"

#If we encountered an error
if result[:ResultCode][0] != "Success"
  #Print the first error message returned
  print result[:Summary][0]+"\n"
else
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
