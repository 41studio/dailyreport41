class AddEndLetterToReports < ActiveRecord::Migration
  def change
    add_column :reports, :end_letter, :text, default: "If you have any question, feel free to contact me directly and I'll try my best to help.<br><br>Have a wonderful day ;)"
  end
end
