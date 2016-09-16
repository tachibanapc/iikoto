class Board < ActiveRecord::Base
  def yarns
    columns = [:number, :locked, :subject, :updated]
    Yarn.where(board: self.route).order(:updated).select(*columns)
  end
end
