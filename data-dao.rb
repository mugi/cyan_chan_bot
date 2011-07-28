require 'rubygems'
require 'mysql'

class DataDao
  
  def initialize()
    @database = Mysql.connect('localhost', 'cyan_chan_user', 'eWmHHbpAEJ5KaxPe', 'cyan_chan_bot', '', '/opt/local/var/run/mysql5/mysqld.sock')
    @database.query('SET NAMES utf8')
  end
  
  # 引数のパスの前回更新時間を取得する
  def get_updated_at_text_file(file_path)
    sql = "SELECT updated_at FROM text_file_manage WHERE file_path = '"+ Mysql::quote(file_path) +"';" # シングルクォートを含むファイル名対策
    return @database.query(sql).fetch_row()
  end
  
  def update_text_file_manage(updated_at, file_path)
    @database.query("UPDATE text_file_manage SET updated_at = '"+ updated_at +"' WHERE file_path = '"+ Mysql::quote(file_path) +"';")
  end
  
  def insert_text_file_manage(updated_at, file_path)
    sql = "INSERT INTO text_file_manage (updated_at, file_path) VALUES ('"+ updated_at +"', '"+ file_path +"');"
    @database.query(sql)
  end
  
  # fixed テーブルの全てのカラムを取得する
  def select_fixed_by_all
    return @database.query("SELECT text FROM fixed;")
  end
  
  # fixed テーブルからランダムに1件のデータを取得する
  ## 呼び出し回数を記録して少ないものの中からランダムに1件抽出する
  def select_fixed_by_min_use_count_random_limit_one
    sql = "SELECT * FROM fixed WHERE use_count IN (SELECT MIN(use_count) FROM fixed) ORDER BY RAND() LIMIT 1;"
    return @database.query(sql).fetch_row()
  end
  
  def update_fixed_use_count(text, use_count)
    use_count = use_count.to_s # to_s 使った後に + は使えないらしいのでここで行う
    @database.query("UPDATE fixed SET use_count = "+ use_count +" WHERE text = '"+ text +"';")
  end
  
  # 同じ定型文がすでに登録されているか調べる
  def select_fixed_by_text(sentence)
    return @database.query("SELECT text FROM fixed WHERE text = '"+ sentence +"';").num_rows()
  end
  
  def insert_fixed(text)
    @database.query("INSERT INTO fixed (text) VALUES ('"+ text +"');")
  end
  
end
