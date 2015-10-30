// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "../../../deps/phoenix/web/static/js/phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

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
  ctx.fillStyle = (isAlive ? "green" : "transparent")
  ctx.fillRect(
    10 + (x - 1) * canvasUnitSize,
    10 + (y - 1) * canvasUnitSize,
    canvasUnitSize,
    canvasUnitSize
  )
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
}

channel.on("render", payload => {
  render(payload.size, payload.cells)
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
