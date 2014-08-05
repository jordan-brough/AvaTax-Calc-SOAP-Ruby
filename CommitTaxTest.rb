require 'avatax_taxservice'

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

commitTaxRequest = {  
  # Required Request Parameters
  :companycode => "APITrialCompany",
  :doctype => "SalesInvoice",
  :doccode => "INV001-1",

  # Optional Request Parameters
  :newdoccode => "INV001"
}
  
commitTaxResult = taxSvc.committax(commitTaxRequest)

# Print Results
puts "CommitTaxTest ResultCode: " + commitTaxResult[:result_code]
if commitTaxResult[:result_code] != "Success"
  if commitTaxResult[:messages][0].nil? 
    puts commitTaxResult[:messages][:message][:summary]
  else
    commitTaxResult[:messages].each { |message| puts message[:details] }
  end
end