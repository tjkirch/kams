# A quest is a descriptive container for objectives, each of which take the form
#   :type => goal
# OR
#   :type => [goal1, goal2]
# For example, a quest could involve killing a bat and a rat, going to room 3,
# and talking to Bob:
#   @objectives = {:kill => [Bat, Rat], :location => room3, :talk => Bob}
class Quest
  attr_reader :id, :name, :description, :objectives

  def initialize(name, description)
    @name, @description = name, description
    @id = $manager.next_quest_id
    @objectives = {}
  end

  # Add a hash of objectives to the quest.
  # If you pass the same key, add them into an array.  For example:
  #   {:kill => Bat}  +  {:kill => Toad}  =  {:kill => [Bat, Toad]}
  # Duplicates are OK, for example killing 10 bats.
  def add_objectives(h)
    @objectives.merge!(h) do |key, old, new|
      if old.is_a? Array
        old << new
      else
        [old] << new
      end
    end
  end
end
