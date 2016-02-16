class Measurement < ActiveRecord::Base
  validates_numericality_of :value

  belongs_to :timeline

  def self.after_date(time, inclusive = false)
    if time.blank?
      all
    else
      if inclusive
        where('timestamp>=?', time)
      else
        where('timestamp>?', time)
      end
    end
  end

  def self.before_date(time, inclusive = false)
    if time.blank?
      all
    else
      if inclusive
        where('timestamp<=?', time)
      else
        where('timestamp<?', time)
      end
    end
  end

end
