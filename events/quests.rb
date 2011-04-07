# Quests passed in from the user input will be integers.
# We only convert to a real Quest object as needed.
module Quests
  def self.accept(event, player, room)
    player.add_quest(event[:quest_id]) if not player.on_quest?(event[:quest_id])
  end

  def self.abandon(event, player, room)
    player.remove_quest(event[:quest_id]) if player.on_quest?(event[:quest_id])
  end
end
