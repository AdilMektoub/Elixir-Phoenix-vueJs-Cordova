defmodule Theme01.Management.UserTeam do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "users_teams" do
    belongs_to :user, Theme01.Management.User
    belongs_to :team, Theme01.Management.Team
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:user_id, :team_id])
    |> unique_constraint([:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
  end
end