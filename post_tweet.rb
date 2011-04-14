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
# tweet = data_dao.select_fixed_by_random_limit_one  # fixed テーブルからランダムに1件取得する
result = data_dao.select_fixed_by_min_use_count_random_limit_one
rowid = result[0][0]
tweet = result[0][1]
use_count = result[0][2] + 1

response = access_token.post(
  'http://twitter.com/statuses/update.json',
  'status'=> tweet
)
puts tweet # debug

data_dao.update_fixed_use_count(rowid, use_count) # 使用回数を +1 して UPDATE する
