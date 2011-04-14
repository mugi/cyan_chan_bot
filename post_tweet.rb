require 'rubygems'
require 'oauth'
require 'oauth-patch'
require 'data-dao'

data_dao = DataDao.new()

CONSUMER_KEY = "gyYB8yUPMDPOonvTCvuQg"
CONSUMER_SECRET = "TiBesqQDtBvPL1uzvfZTnS4ND4imHa0EodgTCXYCM"
ACCESS_TOKEN = "187063533-lyIP1FiYmdR8yzToycqeJ3Fs1YW8SxqHgcTTQe4D"
ACCESS_TOKEN_SECRET = "wGBEtsz6lIjnszFdJlUXZdjJVOmj3L1HoMRJ89fCyQ"

# 下準備
consumer = OAuth::Consumer.new(
  CONSUMER_KEY,
  CONSUMER_SECRET,
  :site => 'http://twitter.com'
)
access_token = OAuth::AccessToken.new(
  consumer,
  ACCESS_TOKEN,
  ACCESS_TOKEN_SECRET
)
# SELECT * FROM entry ORDER BY RANDOM();

# Tweetの投稿
tweet = data_dao.select_fixed_by_random_limit_one  # fixed テーブルからランダムに1件取得する
response = access_token.post(
  'http://twitter.com/statuses/update.json',
  'status'=> tweet
)
puts tweet # debug
