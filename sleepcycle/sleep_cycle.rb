# 睡眠サイクルに関する操作
# ノンレム睡眠・・・脳の眠り(深い)
# レム睡眠・・・身体の眠り(浅い)
# レム睡眠の状態で起きると気分スッキリ
# 90分周期でノンレム睡眠とレム睡眠が入れ替わる。
module SleepCycle
  ONE_HOUR = 60
  ONE_MINUTE = 60
  CYCLE = 90

  # レム睡眠になる時間を求める
  # param：times => 何回目のレム睡眠時間を指定
  # return：レム睡眠時間
  def rem_time(times = 1)
    self + min_to_sec(CYCLE * times)
  end

  # ノンレム睡眠になる時間を求める
  # param：times => 何回目のレム睡眠時間を指定
  # return：レム睡眠時間
  def nonrem_time(times = 1)
    if times == 0
	    self
    else
      sign = if times > 0 
               1
  	     elsif times < 0 
	       -1 
	     end
      self + sign * (min_to_sec(CYCLE / 2) + min_to_sec(CYCLE * (times.abs - 1)))
    end
  end

  private
  # 分を秒に変換
  # 例) min=20 => 20 * 60 = 1200 
  def min_to_sec(min)
    m_sec = min * ONE_MINUTE if min && min >= 0
    m_sec
  end
end

