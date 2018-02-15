class RiskDiceCalculator
  def calculate(att_troops, def_troops)
    a = [1, 2, 3, 4, 5, 6]
    result = {
      win: 0,
      lose: 0,
      tie: 0,
      total: 0
    }
    a.repeated_permutation(att_troops).each do |att_dices|
      a.repeated_permutation(def_troops).each do |def_dices|
        sorted_att_dices = att_dices.sort.reverse
        sorted_def_dices = def_dices.sort.reverse
        min_dices_count = [sorted_att_dices.size, sorted_def_dices.size].min

        win = 0
        lose = 0
        min_dices_count.times do |i|
          if sorted_att_dices[i] > sorted_def_dices[i]
            win += 1
          else
            lose += 1
          end
        end

        result[:total] += 1
        if win == 1 && lose == 1
          result[:tie] += 1
        elsif win > 0
          result[:win] += 1
        else
          result[:lose] += 1
        end
      end
    end
    result
  end
end

calculator = RiskDiceCalculator.new
(1..3).each do |att_troops|
  (1..2).each do |def_troops|
    result = calculator.calculate(att_troops, def_troops)
    total = result[:total]

    win = result[:win]
    win_percentage = (result[:win].to_f / total.to_f * 100.0).round(5)

    lose = result[:lose]
    lose_percentage = (result[:lose].to_f / total.to_f * 100.0).round(5)

    tie = result[:tie]
    tie_percentage = (result[:tie].to_f / total.to_f * 100.0).round(5)

    puts "#{att_troops}:#{def_troops} - total:#{total} win:#{win}(#{win_percentage}%), lose:#{lose}(#{lose_percentage}%), tie:#{tie}(#{tie_percentage}%)"
  end
end
