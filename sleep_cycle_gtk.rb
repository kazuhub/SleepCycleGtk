require "gtk2"
require "sleepcycle/sleep_cycle"

# 睡眠サイクル(レム睡眠、ノンレム睡眠)による
# 浅い眠りになる時間を表示するアプリ
class SleepCycleGtk
  # ウインドウの幅・高さ 
  W_WIDTH = 400
  W_HEIGHT = 400

  attr_reader :window, :exe_button, :quit_button, :time, :rem_radio, :nonrem_radio

  def initialize
    # window
    @window = Gtk::Window.new
    @window.title = "SleepCycle"
    @window.set_default_size(W_WIDTH, W_HEIGHT)
    @window.signal_connect("destroy") {Gtk.main_quit}

    @v_box = Gtk::VBox.new(false, 0)
    h_box_1 = Gtk::HBox.new(false, 10)
    h_box_1.border_width = 5 
    h_box_2 = Gtk::HBox.new(false, 10)
    h_box_2.border_width = 5 

    # condition
    t_label = Gtk::Label.new("現在時間：")
    @time = Gtk::Label.new(Time.now.strftime("%H:%M:%S"))
    @rem_radio = Gtk::RadioButton.new("レム(浅い眠り)")
    @nonrem_radio = Gtk::RadioButton.new(@rem_radio, "ノンレム(深い眠り)")
    h_box_1.pack_start(t_label, false, false, 0)
    h_box_1.pack_start(@time, false, false, 0)
    h_box_1.pack_start(@rem_radio, false, false, 0)
    h_box_1.pack_start(@nonrem_radio, false, false, 0)
   
    # button 
    h_box_2.pack_start(@exe_button = exe_button, false, false, 0)
    h_box_2.pack_start(@quit_button = quit_button, false, false, 0)
    
    @v_box.pack_start(
  	                 hb1_align = Gtk::Alignment.new(0.5, 1, 0, 0),
		         false, 
		         false, 
		         0
		      )
    hb1_align.add(h_box_1)

    @v_box.pack_start(
  	                 hb2_align = Gtk::Alignment.new(0.5, 1, 0, 0),
		         false, 
		         false, 
		         0
		      )
    hb2_align.add(h_box_2)

    # separator
    @v_box.pack_start(Gtk::HSeparator.new, false, true, 5)
    @window.add(@v_box)
  end

  def show
    Gtk.timeout_add(1000) { refreash }
    @window.show_all
    Gtk.main
  end

  def quit
    Gtk.main_quit
  end

  private

  # 実行ボタン
  # クリックで時間表示
  def exe_button
    btn = Gtk::Button.new("実行")
    btn.signal_connect("clicked") do
      # 現在表示リスト削除
      @v_box.each do |w| 
        if w == @result_list
	  @v_box.remove(@result_list)
	  break
	end
      end

      @result_list = Gtk::VBox.new(false, 5)
      t = Time.now
      t.extend(SleepCycle)
      self.result_list = if @rem_radio.active? 
		           Array.new(5) do |i|
	                     (i + 1).to_s << ". " << t.rem_time(i + 1).strftime("%H:%M:%S")
			   end
			 elsif @nonrem_radio.active?
		           Array.new(5) do |i|
	                     (i + 1).to_s << ". " << t.nonrem_time(i + 1).strftime("%H:%M:%S")
			   end
			 else
		           []
			 end
				 
      @v_box.pack_start(@result_list, false, true, 0)
      @window.show_all 
    end
    btn
  end

  # 終了ボタン
  def quit_button
    btn = Gtk::Button.new("終了")
    btn.signal_connect("clicked") do
      self.quit
    end

    btn
  end

  def result_list=(labels)
    if labels.respond_to?(:each)
      labels.each {|e| @result_list.pack_start(Gtk::Label.new(e.to_s), false, false, 5)}
    else
      @result_list.pack_start(Gtk::Label.new(labels.to_s), false, false, 0)
    end
  end

  def refreash
    @time.label = Time.now.strftime("%H:%M:%S")
  end
end

if __FILE__ == $0
  SleepCycleGtk.new.show
end
