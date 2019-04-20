import {Socket} from "phoenix";

let socket = new Socket("/socket", {params: {}});

socket.connect();

let channel = socket.channel("game:example", { name: document.getElementById("player").innerHTML });
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) });

channel.on("tell", resp => {
  console.log(resp);
  channel
    .push("act", { actions: [Math.random()] })
    .receive("thanks", resp => console.log("thanks"));
});

export default socket;
