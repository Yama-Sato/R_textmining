library(rtweet)
library(RMeCab)

## �F�؃Z�b�V����
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
# get_trend�@��15����15��?

now_time <- sprintf("%d_%d_%d_%d",unclass(as.POSIXlt(Sys.time()))$mon+1,unclass(as.POSIXlt(Sys.time()))$mday,unclass(as.POSIXlt(Sys.time()))$hour,unclass(as.POSIXlt(Sys.time()))$min)

japan_trend <- get_trends(woeid=23424856)

file_name_trend <- sprintf("F:/�w�Z�֌W/�[�~2/output_data/output_japan_trend%s.txt",now_time)

write.table(japan_trend, file_name_trend)

# search_tweet ��15����180��܂�
# trend ��1���46�����Ă����
# trend�@�̌v�Z�͔����W���̒l�ŎZ�o����Ă��邽�߁A�c�C�[�g�̑��� tweet_volume�@�łȂɂ�������͓̂����
# R dataframe�^�̒l�̎Q�Ƃ͔z��̂悤�� japan_trend[row,column]��OK�A�l����Ȃ��Ď��ł��Q�Ɖ� japan_trend[japan_trend$tweet_volume>10000,]

for(i in 1:nrow(japan_trend)){
	#�t�@�C���l�[���ݒ�
	file_name_text <- sprintf("F:/�w�Z�֌W/�[�~2/output_data/output_japan_trend_tweets%s_%d.txt",now_time,i)
	file_name_freq <- sprintf("F:/�w�Z�֌W/�[�~2/output_data/output_freq%s_%d.txt",now_time,i)

	#�g�����h�̒P�ꂪ�܂܂�Ă���c�C�[�g�������Ă���
	tweets <- search_tweets(q = japan_trend[i,1], n = 100, include_rts = FALSE)
	write.table(tweets$text, file_name_text, quote=F, col.names=F, row.names=F)

	#�`�ԑf���
	#result�̒��� $Term,$Info1,$Info2,$Freq�̃f�[�^������
	result = RMeCabFreq(file_name_text)

	# �p�x�\�̍쐬(N�ȏ�܂܂�Ă���P��̂�)
	for(j in 1:nrow(result)){
		if(result[j,"Freq"]>=40){
			x <- data.frame(term = c(result[j,"Term"]), freq = c(result[j,"Freq"]))
			write.table(x, file_name_freq, append=T, quote=F, col.names=F, row.names=F)
		}
	}
} 

## XX �̓T�[�`����������
#tweet <- search_tweets(q = "�V���[�y��", n = 10000, include_rts = FALSE)

## tweet �ɂ�json�`���ŏo�͂������Ă���͂�
## tweet$text�Ńe�L�X�g�݂̂������Ă����c�H

#write(tweet$text,"G:/�w�Z�֌W/�[�~2/output_tweet_sharppen_text.txt")

##�@�����Ă��ꂽ���ǂǂ�����ǂ��܂ł����P�̃c�C�[�g�����킩��Ȃ�
## write.table()�ōs�ԍ���Y�t�ł��Ȃ����H->�ł���
## ���ƃ��v���C�͒e������->C#�v���O�����Ő��`����

#write.table(tweet$text,"G:/�w�Z�֌W/�[�~2/output_tweet_sharppen_table_text.txt",quote=F,col.names=F)

