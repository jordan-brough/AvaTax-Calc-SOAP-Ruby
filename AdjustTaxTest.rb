require 'Avatax_TaxService'
require 'yaml'

credentials = YAML::load(File.open('credentials.yml'))

# Header Level Parameters
taxSvc = AvaTax::TaxService.new(

# Required Header Parameters
  :username => credentials['account_number'], 
  :password => credentials['license_key'],  
  :use_production_url => credentials['use_production_url'],
  :clientname => "AvaTaxSample",

# Optional Header Parameters  
  :name => "Development") 

adjustTaxRequest = {  
  # AdjustTax Level Parameters
  # Required Request Parameters
  :adjustmentreason => 4,
  :adjustmentdescription => "Transaction Adjusted for Testing",
  # GetTaxRequest Level Parameters
  # Required Request Parameters
  :customercode => "ABC4335",
  :docdate => "2014-01-01",
  
  # Best Practice Request Parameters
  :companycode => "APITrialCompany",
  :doccode => "INV001",
  :detaillevel => "Tax",
  :commit => false,
  :doctype => "SalesInvoice",

  # Situational Request Parameters
  # :businessidentificationno => "234243",
  # :customerusagetype => "G",
  # :exemptionno => "12345",
  # :discount => 50,
  # :locationcode => "01",
  # :taxoverridetype => "TaxDate",
  # :reason => "Adjustment for return",
  # :taxdate => "2013-07-01",
  # :taxamount => "0",
  # :servicemode => "Automatic",

  # Optional Request Parameters
  :purchaseorderno => "PO123456",
  :referencecode => "ref123456",
  :poslanecode => "09",
  :currencycode => "USD",
  :exchangerate => "1.0",
  :exchangerateeffdate => "2013-01-01",
  :salespersoncode => "Bill Sales",

  # Address Data
  :addresses => 
  [
    {
    :addresscode => "01",
    :line1 => "45 Fremont Street",
    :city => "San Francisco",
    :region => "CA",
    },
    {
    :addresscode => "02",
    :line1 => "118 N Clark St",
    :line2 => "Suite 100",
    :line3 => "ATTN Accounts Payable",
    :city => "Chicago",
    :region => "IL",
    :country => "US",
    :postalcode => "60602",
    },
    {
    :addresscode => "03",
    :latitude => "47.627935",
    :longitude => "-122.51702",
    }
  ],

  # Line Data
  :lines => 
  [
    {
    
    # Required Parameters
    :no => "01",
    :itemcode => "N543",
    :qty => 1,
    :amount => 10,
    :origincodeline => "01",
    :destinationcodeline => "02",

    # Best Practice Request Parameters
    :description => "Red Size 7 Widget",
    :taxcode => "NT",

    # Situational Request Parameters
    # :customerusagetype => "L",
    # :exemptionno => "12345",
    # :discounted => true,
    # :taxincluded => true,
    # :taxoverridetypeline => "TaxDate",
    # :reasonline => "Adjustment for return",
    # :taxdateline => "2013-07-01",
    # :taxamountline => "0",

    # Optional Request Parameters
    :ref1 => "ref123",
    :ref2 => "ref456",
    },
    {
    :no => "02",
    :itemcode => "T345",
    :qty => 3,
    :amount => 150,
    :origincodeline => "01",
    :destinationcodeline => "03",
    :description => "Size 10 Green Running Shoe",
    :taxcode => "PC030147",
    },
    {
    :no => "02-FR",
    :itemcode => "FREIGHT",
    :qty => 1,
    :amount => 15,
    :origincodeline => "01",
    :destinationcodeline => "03",
    :description => "Shipping Charge",
    :taxcode => "FR",
    }
  ]
}

adjustTaxResult = taxSvc.adjusttax(adjustTaxRequest)

# Print Results
puts "AdjustTaxTest ResultCode: " + adjustTaxResult[:result_code]
if adjustTaxResult[:result_code] != "Success"
  if adjustTaxResult[:messages][0].nil? 
    adjustTaxResult[:messages][:message].each { |message| puts message[:summary] }
  else
    adjustTaxResult[:messages].each { |message| puts message[:summary] }
  end
else
  puts "Document Code: " + adjustTaxResult[:doc_code] + 
    " Total Tax: " + adjustTaxResult[:total_tax].to_s
  adjustTaxResult[:tax_lines][:tax_line].each do |taxLine|
      puts "    " + "Line Number: " + taxLine[:no] + " Line Tax: " + taxLine[:tax].to_s
      taxLine[:tax_details][:tax_detail].each do |taxDetail| 
          puts "        " + "Jurisdiction: " + taxDetail[:juris_name] + " Tax: " + taxDetail[:tax].to_s
      end
  end
end