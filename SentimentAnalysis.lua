--//prsho
SentimentAnalysis = {["Positive"]={},["Negative"]={},["Neutral"]={}}
function SentimentAnalysis:Analyze(assetId,startIndex,api_key,prnt) --api_key from datumbox.com | prnt is bool (true/false) that prints out results in output
	local hs = game:GetService("HttpService")
	local RawComments = hs:GetAsync("https://rproxy.pw/API/Comments.ashx?rqtype=getComments&assetID="..assetId.."&startIndex="..startIndex, true)
	local luaRawComments = hs:JSONDecode(RawComments)
	for k,v in pairs(luaRawComments["data"]) do
		local data = "api_key="..api_key.."&text="..v["Content"]
		local SentimentReturn = hs:PostAsync("http://api.datumbox.com/1.0/SentimentAnalysis.json",data,Enum.HttpContentType.ApplicationUrlEncoded)
		local Sentiment = hs:JSONDecode(SentimentReturn)
		if Sentiment["output"]["status"] == 1 then
			local value = Sentiment["output"]["result"]
			if value == "positive" then
				table.insert(SentimentAnalysis["Positive"],{v["AuthorID"],v["Content"]})
			elseif value == "negative" then
				table.insert(SentimentAnalysis["Negative"],{v["AuthorID"],v["Content"]})
			else
				table.insert(SentimentAnalysis["Neutral"],{v["AuthorID"],v["Content"]})
			end
		end
	end
	if prnt == true then
		print(hs:JSONEncode(SentimentAnalysis),
			"Positive: "..#SentimentAnalysis["Positive"],
			" | Negative: "..#SentimentAnalysis["Negative"],
			" | Neutral: "..#SentimentAnalysis["Neutral"])
	end
end
return SentimentAnalysis