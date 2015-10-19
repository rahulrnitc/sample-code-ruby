  require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  request = CreateTransactionRequest.new
  
  payPalType = PayPalType.new()
  payPalType.successUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
  payPalType.cancelUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
  #payerID should be taken from GetDetails
  payPalType.payerID = "S6D5ETGSVYX94"
  
  #standard api call to retrieve response
  paymentType = PaymentType.new()
  paymentType.payPal = payPalType
  
  request.transactionRequest = TransactionRequestType.new()
  request.transactionRequest.amount = 813.45
  request.transactionRequest.payment = paymentType
  #refTransId should be taken from the transId returned by AuthOnly
  request.transactionRequest.refTransId = "2241762126"
  request.transactionRequest.transactionType = TransactionTypeEnum::AuthOnlyContinueTransaction 
  response = transaction.create_transaction(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successful AuthOnly Transaction (Transaction response code: #{response.transactionResponse.responseCode})"
    #puts response.messages.messages[0].text
    #puts response.transactionResponse.to_yaml
    puts response.transactionResponse.messages.messages[0].code
    puts response.transactionResponse.messages.messages[0].description
  else
    puts response.messages.messages[0].text
    puts response.transactionResponse.errors.errors[0].errorCode
    puts response.transactionResponse.errors.errors[0].errorText
    raise "Failed to authorize card."
  end