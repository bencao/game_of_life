// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "../../../deps/phoenix/web/static/js/phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("game:game_of_life", {})

const canvasUnitSize = 8

const resetCanvas = function(ctx, size) {
  ctx.clearRect(
    10,
    10,
    size * canvasUnitSize,
    size * canvasUnitSize
  )
}

const paintCell = function(ctx, x, y, isAlive) {
  ctx.fillStyle = (isAlive ? "black" : "white")
  ctx.fillRect(
    10 + (x - 1) * canvasUnitSize,
    10 + (y - 1) * canvasUnitSize,
    canvasUnitSize,
    canvasUnitSize
  )
}

const print = function(size, cells) {
  let table = []
  for (let i = 0; i < size; i ++) {
    table.push(cells.slice(i * size, (i + 1) * size))
  }
  console.table(table)
}

const render = function(size, cells) {
  let canvas = document.getElementById("main")
  let ctx    = canvas.getContext("2d")

  resetCanvas(ctx, 800)

  cells.forEach(function(cell, index) {
    let x = index % size
    let y = Math.floor(index / size)
    paintCell(ctx, x, y, cell === 1)
  })

  print(size, cells)
}

channel.on("render", payload => {
  render(payload.size, payload.cells)
})

const startFps = function(fps) {
  setInterval(() => channel.push("refresh", {}), 1000/fps)
}

startFps(60)

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
