defmodule Theme01Web.TeamController do
  use Theme01Web, :controller

  alias Theme01.Management
  alias Theme01.Management.{Team, UserTeam}

  action_fallback Theme01Web.FallbackController

  def index(conn, _params) do
    teams = Management.list_teams()
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Management.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, team))
      |> render("show.json", team: team)
    end
  end

  def add_team_member(conn, %{"teamID" => teamID, "userID" => userID}) do
    with {:ok, %UserTeam{} = _user_team} <- Management.add_user_in_team(teamID, userID) do
      team = Management.get_team!(teamID)
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, teamID))
      |> render("show_user_team.json", team: team)
    end
  end

  def show(conn, %{"teamID" => id}) do
    team = Management.get_team!(id)
    render(conn, "show.json", team: team)
  end

  def update(conn, %{"teamID" => id, "team" => team_params}) do
    team = Management.get_team!(id)

    with {:ok, %Team{} = team} <- Management.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

  def delete(conn, %{"teamID" => id}) do
    team = Management.get_team!(id)

    with {:ok, %Team{}} <- Management.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
