extends Node2D

############################
#   Change the API KEYS!   #
############################
const CARDANOSCAN_HEADERS: PackedStringArray = (["apiKey:XXXXXXXXXX-XXXXXXXXXX-XXXXXXXXXX"]);

const CARDANOSCAN_URL_LATEST_BLOCK : String = "https://api.cardanoscan.io/api/v1/block/latest";
const CARDANOSCAN_URL_ADDRESS_BALANCE : String = "https://api.cardanoscan.io/api/v1/address/balance?address=";
const COINGECKO : String = "https://api.coingecko.com/api/v3/simple/price?ids=cardano&vs_currencies=eur";

## Get "Cardano Price" from CoinGecko API
func get_cardano_price() -> void:
    var price_request : Error = ($ApiPrice as HTTPRequest).request(COINGECKO)
    match price_request:
        !OK: (get_parent().get_node("Price") as RichTextLabel).text = "[center]Price: N/A"

## Process "Cardano Price Data" from CoinGecko API
func _on_api_price_request_completed(_result, _response_code, _headers, body) -> void:
    var price_data : JSON = JSON.new()
    var check_error : Error = price_data.parse(body.get_string_from_utf8())
    match check_error:
        OK: 
            var resposta : float = price_data.get_data()["cardano"]["eur"]
            (get_parent().get_node("Price") as RichTextLabel).text = "[center]Price: "  + str("%.2f" % resposta) + " €"
        _:
            (get_parent().get_node("Price") as RichTextLabel).text = "[center]Price: N/A"


## Get "Epoch/Transactions" from CardanoScan API
func get_epochs():
    var chain_request : Error = ($ApiEpoch as HTTPRequest).request(CARDANOSCAN_URL_LATEST_BLOCK,CARDANOSCAN_HEADERS)
    match chain_request:
        !OK:
            (get_parent().get_node("Epoch") as RichTextLabel).text = "[center]Epoch: N/A"
            (get_parent().get_node("TXsCount") as RichTextLabel).text = "[center]TXsCount: N/A"

## Process "Epoch/Transactions Data" from CardanoScan API
func _on_api_epoch_request_completed(_result, _response_code, _headers, body) -> void:
    var chain_data : JSON = JSON.new()
    var check_error : Error = chain_data.parse(body.get_string_from_utf8())
    match check_error:
        OK:
            match get_parent().name:
                "Menu": 
                    var resposta = chain_data.get_data()["epoch"]
                    var resposta2 = chain_data.get_data()["txCount"]
                    (get_parent().get_node("Epoch") as RichTextLabel).text = "[center]Current Epoch #" + str(resposta)
                    (get_parent().get_node("TXsCount") as RichTextLabel).text = "[center]Txs in last block:  " + str(resposta2)
                "Explorer":
                    (get_parent().get_node("Panel/UserResults") as RichTextLabel).text = ""
                    var dict = chain_data.get_data()
                    var dict_data = "";
                    for item in dict:
                        if item == "balance":
                            print(item)
                            print(dict[item])
                            dict_data += str(item) + " : " + str((float(dict[item])/1000000)) + " lovelaces\n"
                        else:
                            dict_data += str(item) + " : " + str(dict[item]) + "\n"
                    (get_parent().get_node("Panel/UserResults") as RichTextLabel).text += "[center][font_size=30]" + dict_data
        _:
            match get_parent().name:
                "Menu": 
                    (get_parent().get_node("Epoch") as RichTextLabel).text = "[center]Epoch: N/A"
                    (get_parent().get_node("TXsCount") as RichTextLabel).text = "[center]TXsCount: N/A"
                "Explorer":
                    (get_parent().get_node("Panel/UserResults") as RichTextLabel).text = "[center][font_size=40]API N/A at the moment."

func get_cardano_transaction(user_text):
    if user_text.begins_with("addr") || user_text.begins_with("stake"):
        var tx_request : Error = ($ApiEpoch as HTTPRequest).request(CARDANOSCAN_URL_ADDRESS_BALANCE + user_text,CARDANOSCAN_HEADERS)
        match tx_request:
            !OK:
                match get_parent().name:
                    "Explorer":
                        (get_parent().get_node("Panel/UserResults") as RichTextLabel).text = "[center][font_size=40]API N/A at the moment."
    else:
        var tx_request : Error = ($ApiEpoch as HTTPRequest).request(CARDANOSCAN_URL_LATEST_BLOCK,CARDANOSCAN_HEADERS)
        match tx_request:
            !OK:
                match get_parent().name:
                    "Explorer":
                        (get_parent().get_node("Panel/UserResults") as RichTextLabel).text = "[center][font_size=40]API N/A at the moment."