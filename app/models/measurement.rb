class Measurement < ActiveRecord::Base
  self.primary_key = "id"

  validates_numericality_of :value

  belongs_to :timeline

  before_create :set_child_name
  after_create :restore_generic_name

  private

  def set_child_name
    base_date = Date.parse('2015-01-01')
    table_name = ''

    if m_timestamp < base_date
      table_name = 'measurements_child_1970_01_01'
    else
      for i in 0..60 do
        not_before = base_date.to_s
        not_before_name = not_before.gsub('-','_')
        if (m_timestamp >= base_date) && (m_timestamp < base_date+1.month)
          table_name = 'measurements_child_'+not_before_name
        end
        base_date += 1.month
      end
    end
    Measurement.table_name = table_name
  end

  def restore_generic_name
    Measurement.table_name = 'measurements'
  end

  def self.after_date(time, inclusive = false)
    if time.blank?
      all
    else
      if inclusive
        where('m_timestamp>=?', time)
      else
        where('m_timestamp>?', time)
      end
    end
  end

  def self.before_date(time, inclusive = false)
    if time.blank?
      all
    else
      if inclusive
        where('m_timestamp<=?', time)
      else
        where('m_timestamp<?', time)
      end
    end
  end

end
