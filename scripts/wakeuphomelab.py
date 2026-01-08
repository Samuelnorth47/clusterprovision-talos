import os
import subprocess
import time
from wakeonlan import send_magic_packet

NODES = {
    "mercury": {
        "ip": "192.168.20.11",
        "mac": os.environ["mercury_mac"],
    },
    "venus": {
        "ip": "192.168.20.10",
        "mac": os.environ["venus_mac"],
    },
    "neptune": {
        "ip": "192.168.20.12",
        "mac": os.environ["neptune_mac"],
    },
    "pluto": {
        "ip": "192.168.20.13",
        "mac": os.environ["pluto_mac"],
    },
    "saturn": {
        "ip": "192.168.20.14",
        "mac": os.environ["saturn_mac"],
    },
}

BROADCAST_IP = "192.168.20.255"

def is_host_up(ip):
    result = subprocess.run(
        ["ping", "-c", "1", "-W", "1", ip],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return result.returncode == 0

def wake_host(name, mac):
    print(f"[!] {name} is DOWN — sending WoL")
    send_magic_packet(mac, ip_address=BROADCAST_IP)
    time.sleep(1)

def main():
    for name, data in NODES.items():
        wait = False
        ip = data["ip"]
        mac = data["mac"]

        print(f"[+] Checking {name} ({ip})")

        if is_host_up(ip):
            print(f"[✓] {name} is already UP")
        else:
            wake_host(name, mac)
            wait = True
    
    if wait:
        print("[!] Waiting for hosts to wake up...")
        time.sleep(30)

if __name__ == "__main__":
    main()
