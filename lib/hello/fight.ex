defmodule HelloWeb.Fight do
  def fight(character_1, character_2) do
    stamina = fn character ->
      if character.stamina > 0 do
        IO.inspect("#{character.name} de #{character.color} reçoit 1 dégat")
        %{character | stamina: character.stamina - 1}
      else
        character
      end
    end

    {stamina.(character_1), stamina.(character_2)}
  end
end
