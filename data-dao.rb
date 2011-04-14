require 'rubygems'
require 'sqlite3'

class DataDao
  
  def initialize()
    @database = SQLite3::Database::new("./dictionary.sqlite3")
  end
  
  # 引数のパスの前回更新時間を取得する
  def get_updated_at_text_file(file_path)
    return @database.get_first_value("SELECT updated_at FROM text_file_manage WHERE file_path = ?", file_path)
  end
  
  def update_text_file_manage(updated_at, file_path)
    @database.execute("UPDATE text_file_manage SET updated_at = ? WHERE file_path = ?", updated_at, file_path)
  end
  
  def insert_text_file_manage(updated_at, file_path)
    @database.execute("INSERT INTO text_file_manage (updated_at, file_path) VALUES (?, ?)", updated_at, file_path)
  end
  
  # fixed テーブルの全てのカラムを取得する
  def select_fixed_by_all
    return @database.execute("SELECT text FROM fixed;")
  end
  
  # fixed テーブルからランダムに1件のデータを取得する
  def select_fixed_by_random_limit_one
    return @database.execute("SELECT text FROM fixed ORDER BY RANDOM() LIMIT 1;")
  end
  
  # 同じ定型文がすでに登録されているか調べる
  def select_fixed_by_text(sentence)
    return @database.get_first_value("SELECT rowid FROM fixed WHERE text = '"+ sentence +"';")
  end
  
  def insert_fixed(text)
    @database.execute("INSERT INTO fixed (text) VALUES (?)", text)
  end
  
end
