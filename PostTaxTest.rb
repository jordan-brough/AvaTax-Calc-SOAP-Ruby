require 'Avatax_TaxService'

accountNumber = "1234567890"
licenseKey = "A1B2C3D4E5F6G7H8"
useProductionURL = false

# Header Level Parameters
taxSvc = AvaTax::TaxService.new(

# Required Header Parameters
  :username => accountNumber, 
  :password => licenseKey,  
  :use_production_url => useProductionURL,
  :clientname => "AvaTaxSample",

# Optional Header Parameters  
  :name => "Development") 

postTaxRequest = {  
  # Required Request Parameters
  :companycode => "APITrialCompany",
  :doctype => "SalesInvoice",
  :doccode => "INV001",
  :commit => "false",
  :docdate => "2014-01-01",
  :totaltax => "14.27",
  :totalamount => "175",

  # Optional Request Parameters
  :newdoccode => "INV001-1"
}
  
postTaxResult = taxSvc.posttax(postTaxRequest)

# Print Results
puts "PostTaxTest ResultCode: " + postTaxResult[:result_code]
if postTaxResult[:result_code] != "Success"
  if postTaxResult[:messages][0].nil? 
    postTaxResult[:messages][:message].each { |message| puts message[:details] }
  else
    postTaxResult[:messages].each { |message| puts message[:details] }
  end
end