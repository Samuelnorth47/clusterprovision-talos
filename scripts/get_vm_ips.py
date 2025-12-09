from proxmoxer import ProxmoxAPI
import os
# Connect to Proxmox (replace with your host / token or user+pass)
proxmox = ProxmoxAPI(
    os.env("PROXMOX_NODE"),
    user=os.env("PROXMOX_API_USER"),
    token_name= os.env("PROXMOX_API_TOKEN_ID"),
    token_value=os.env("PROXMOX_API_TOKEN_SECRET"),
    verify_ssl=False )

def get_vm_ip(node: str, vmid: int):
    try:
        interfaces = proxmox.nodes(node).qemu(vmid).agent("network-get-interfaces").get()
    except Exception as e:
        print("Could not fetch guest-agent info:", e)
        return None

    for iface in interfaces.get("result", []):
        if iface.get("name") == "lo":
            continue
        for ipinfo in iface.get("ip-addresses", []):
            if ipinfo.get("ip-address-type") == "ipv4":
                return ipinfo.get("ip-address")
    return None

for vm in proxmox.nodes("mercury").qemu.get():
    vmid = vm["vmid"]
    name = vm["name"]
    ip = get_vm_ip("mercury", vmid)
    print(f"VM {name} (ID {vmid}) → IP: {ip}")
