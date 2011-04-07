require 'observer'

# Including classes must have an @inventory if they're given rewards
module HasQuests
  def self.included(base)
    base.send :include, Observable
  end

  def initialize(*args)
    super
    @quests = {}
    @completed_quests = {}
  end

  # @quests is a hash of active quests for a player.  The key is the quest ID
  # and the value is a hash representing the player's progress on that quest:
  #   {:accepted_at => <time>,
  #    :progress => {
  #      :kill => [<mob1>, <mob2>],
  #      :item => <item>,
  #      :location => <room>  (etc.)
  #    }
  #   }
  # Each entry in the :progress hash is a quest objective, and can be an array
  # if there is more than one goal of the same type.
  def add_quest(quest_id)
    if @quests[quest_id]
      self.output "You're already on that quest."
      return false
    elsif @completed_quests[quest_id]
      self.output "You've already completed that quest."
      return false
    end

    @quests[quest_id] = {
      :accepted_at => Time.now,
      :progress => {}
    }

    update_progress(quest_id)
    ### TODO: add observers - per objective or per quest?
  end

  def remove_quest(quest_id)
    @quests.delete quest_id
  end

  def on_quest?(quest_id)
    @quests.include? quest_id
  end

  def update_progress(quest_id)
    ### TODO
  end

  def update_all_quests
    @quests.each do |q|
      update_progress q
    end
  end

  ### TODO: have to move into objective (object) if I decide on an observer per objective.
  #   not yet using any info from the notify_observers call here...
  def update(*args)
    update_all_quests
  end

  # @completed_quests is a hash of (yep) the player's completed quests.  The key
  # is the quest ID and the value is a hash representing the completion info:
  #   {:completed_at=> <time>}
  def complete_quest(quest_id)
    @completed_quests[quest_id] = {
      :completed_at => Time.now
    }
    @quests.delete quest_id

    self.output "You've completed the quest #{quest.name}."

    quest = $manager.find_quest(quest_id)
    quest.rewards.each do |reward|
      r = reward.new
      $manager.add_object r
      self.inventory << r
      self.output "You received a reward: #{r}"
    end
  end
end
