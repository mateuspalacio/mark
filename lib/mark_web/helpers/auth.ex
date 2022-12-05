defmodule MarkWeb.Helpers.Auth do

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: !!Mark.Repo.get(Mark.Accounts.User, user_id)
  end

  def admin?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id > 0 do
      user = Mark.Repo.get(Mark.Accounts.User, user_id)
      String.contains?(user.username, "admin")
    end
  end

end
