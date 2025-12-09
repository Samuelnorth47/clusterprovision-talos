from proxmoxer import ProxmoxAPI
import os
# Connect to Proxmox (replace with your host / token or user+pass)
proxmox = ProxmoxAPI(
    os.env("proxmox_node"),
    user=os.env("proxmox_api_user"),
    token_name= os.env("proxmox_api_token_id"),
    token_value=os.env("proxmox_api_token_secret"),
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
