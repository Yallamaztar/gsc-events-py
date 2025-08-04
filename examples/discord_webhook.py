from gsc_events import GSCClient
import requests

WEBHOOK_URL: str = "https://discord.com/api/webhooks/1402003643535720568/vo7u2BdpkGp3Moy64H16A46GVNT7bN6KhsMHuiZehtqAin97ARVhSiXCNbxI1kbzZXhY"

client = GSCClient()

def send_webhook(content: str) -> None:
    data = { "content": content }
    requests.post(WEBHOOK_URL, json=data)

@client.on("player_connected")
def on_connect(player: str) -> None:
    send_webhook( f"Player {player} joined" )

@client.on("player_say")
def on_say(player: str, message: str) -> None:
    send_webhook( f"{player} - {message}" )

client.run()