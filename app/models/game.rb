class Game < ApplicationRecord
  belongs_to :match
  has_many :points, dependent: :destroy
  after_initialize :set_defaults

  def side_of(player)
      p = CGI.unescape(player.to_s).strip

    return "P" if p == p_front.to_s.strip || p == p_back.to_s.strip
    return "Q" if p == q_front.to_s.strip || p == q_back.to_s.strip
    
    nil
  end

  def set_defaults
    self.p_score ||= 0
    self.q_score ||= 0

    self.final_p_score ||= 0
    self.final_q_score ||= 0

    self.in_final = false if in_final.nil?
  end
end
