from iw4m import IW4MWrapper
from gsc_events import GSCClient
from os import environ
import requests

client = GSCClient()

iw4m = IW4MWrapper(
    base_url  = environ['IW4M_URL'],
    server_id = int(environ['IW4M_ID']),
    cookie    = environ['IW4M_HEADER']
)

player   = iw4m.Player(iw4m)
commands = iw4m.Commands(iw4m)

def is_vpn(ip_address: str) -> bool:
    r = requests.get(f"https://ipapi.co/{ip_address}/json/")
    data = r.json()
    return data.get("privacy", {}).get("vpn", False)

@client.on("player_connected")
def on_connect(client: str) -> None:
    client_id  = player.player_client_id_from_name(client)
    ip_address = player.info(client_id)['ip_address']

    if is_vpn(ip_address):
        commands.kick(f"@{client_id}", "This server does not allow VPN connections")

client.run()