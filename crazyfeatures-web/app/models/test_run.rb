class TestRun < ActiveRecord::Base
  belongs_to :repository

  def to_s
    "#{sha} at #{created_at.to_s} - #{succeeded? ? 'PASS' : 'FAIL'}"
  end

  def succeeded?
    exit_code == 0
  end

  def failed?
    !succeeded?
  end
end
