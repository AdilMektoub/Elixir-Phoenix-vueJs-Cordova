defmodule Theme01Web.TeamView do
  use Theme01Web, :view
  alias Theme01Web.TeamView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    %{id: team.id,
      name: team.name,
      manager: render_one(team.manager, Theme01Web.UserView, "user_team_manager.json"),
      users: render_many(team.users, Theme01Web.UserView, "user_team_manager.json")}
  end

  def render("show_user_team.json", %{team: team}) do
    %{id: team.id,
      name: team.name,
      users: render_many(team.users, Theme01Web.UserView, "user_team_manager.json")}
  end
end
