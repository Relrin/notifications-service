defmodule NotificationsServiceTest do
  use ExUnit.Case
  doctest NotificationsService

  test "greets the world" do
    assert NotificationsService.hello() == :world
  end
end
