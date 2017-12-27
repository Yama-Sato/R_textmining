library(rtweet)
library(RMeCab)

## 認証セッション
consumerKey="fpdLtO45jUdJW4utOo9P4KYg6"
consumerSecret="BaV41NLTHyFv5NCVwhxAUXqMgJK1Z5x4HcDEjLdgpmBNsDk3KJ"
APPNAME = "data_twitter_text_miningpractice"

twitter_token = create_token(
  app = APPNAME,
  consumer_key = consumerKey,
  consumer_secret = consumerSecret)

#1. get japan trend
#2. search tweet from trend words
#3. morpheme analysis those tweets and research what are a lot of used words.
#3.5. sentimental analysis these words and consider whether positive or negative 
#4. organize conclusion
#5. there system loop 15min
#6. output file

# get japan trend
# woeid(where on earth ID) : japan = 23424856
# get_trend　は15分で15回?

now_time <- sprintf("%d_%d_%d_%d",unclass(as.POSIXlt(Sys.time()))$mon+1,unclass(as.POSIXlt(Sys.time()))$mday,unclass(as.POSIXlt(Sys.time()))$hour,unclass(as.POSIXlt(Sys.time()))$min)

japan_trend <- get_trends(woeid=23424856)

file_name_trend <- sprintf("F:/学校関係/ゼミ2/output_data/output_japan_trend%s.txt",now_time)

write.table(japan_trend, file_name_trend)

# search_tweet は15分で180回まで
# trend は1回で46個持ってこれる
# trend　の計算は微分係数の値で算出されているため、ツイートの総量 tweet_volume　でなにかをするのは難しそう
# R dataframe型の値の参照は配列のように japan_trend[row,column]でOK、値じゃなくて式でも参照可 japan_trend[japan_trend$tweet_volume>10000,]

for(i in 1:nrow(japan_trend)){
	#ファイルネーム設定
	file_name_text <- sprintf("F:/学校関係/ゼミ2/output_data/output_japan_trend_tweets%s_%d.txt",now_time,i)
	file_name_freq <- sprintf("F:/学校関係/ゼミ2/output_data/output_freq%s_%d.txt",now_time,i)

	#トレンドの単語が含まれているツイートを持ってくる
	tweets <- search_tweets(q = japan_trend[i,1], n = 100, include_rts = FALSE)
	write.table(tweets$text, file_name_text, quote=F, col.names=F, row.names=F)

	#形態素解析
	#resultの中に $Term,$Info1,$Info2,$Freqのデータがある
	result = RMeCabFreq(file_name_text)

	# 頻度表の作成(N以上含まれている単語のみ)
	for(j in 1:nrow(result)){
		if(result[j,"Freq"]>=40){
			x <- data.frame(term = c(result[j,"Term"]), freq = c(result[j,"Freq"]))
			write.table(x, file_name_freq, append=T, quote=F, col.names=F, row.names=F)
		}
	}
} 

## XX はサーチしたい文字
#tweet <- search_tweets(q = "シャーペン", n = 10000, include_rts = FALSE)

## tweet にはjson形式で出力が入っているはず
## tweet$textでテキストのみを持ってこれる…？

#write(tweet$text,"G:/学校関係/ゼミ2/output_tweet_sharppen_text.txt")

##　持ってこれたけどどこからどこまでかが１つのツイートかがわからない
## write.table()で行番号を添付できないか？->できた
## あとリプライは弾きたい->C#プログラムで整形する

#write.table(tweet$text,"G:/学校関係/ゼミ2/output_tweet_sharppen_table_text.txt",quote=F,col.names=F)


