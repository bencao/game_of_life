defmodule WebUI.PageController do
  use WebUI.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", patterns: Patterns.Loadable.all
  end
end
