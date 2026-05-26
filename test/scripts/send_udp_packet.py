#!/usr/bin/env python3
import sys
from scapy.all import Ether, IP, UDP, Raw, sendp

def send_udp_ethernet(dst_mac, src_mac, dst_ip, src_ip, src_port, dst_port, payload=""):
    """
    Sends a UDP Ethernet packet with configurable MAC source and destination.

    Args:
        interface (str): Ethernet interface name (e.g., "eno0").
        dst_mac (str): Destination MAC address (e.g., "00:11:22:33:44:55").
        src_mac (str): Source MAC address (e.g., "AA:BB:CC:DD:EE:FF").
        dst_ip (str): Destination IP address (e.g., "192.168.1.10").
        src_ip (str): Source IP address (e.g., "192.168.1.1").
        src_port (int): Source UDP port.
        dst_port (int): Destination UDP port.
        payload (str, optional): Payload data. Defaults to "".

    Returns:
        None.  Prints a success/failure message.
    """

    # Create the Ethernet layer
    layer_2         = Ether(src=src_mac, dst=dst_mac)
    layer_3         = IP(src=src_ip, dst=dst_ip)
    layer_4         = UDP(sport=src_port, dport=dst_port)
    load            = Raw (load = payload);
    packet          = layer_2 / layer_3 / layer_4 / load  # Construct the packet
    original_size   = len(packet)
    target_size     = 60
    padding_needed  = target_size - original_size
    padding_bytes   = 'x' * padding_needed
    packet          = packet/ Raw(load=padding_bytes)

    try:
        sendp(packet, verbose=0)  # Send the packet.  verbose=0 suppresses verbose output.
        print(f"Ethernet packet sent successfully: {packet.summary()}")
    except Exception as e:
        print(f"Error sending packet: {e}")

def send_udp_ramp(dst_mac, src_mac, dst_ip, src_ip, src_port, dst_port, ramp_size):
    """
    Sends a UDP Ethernet packet with configurable MAC source and destination.

    Args:
        interface (str): Ethernet interface name (e.g., "eno0").
        dst_mac (str): Destination MAC address (e.g., "00:11:22:33:44:55").
        src_mac (str): Source MAC address (e.g., "AA:BB:CC:DD:EE:FF").
        dst_ip (str): Destination IP address (e.g., "192.168.1.10").
        src_ip (str): Source IP address (e.g., "192.168.1.1").
        src_port (int): Source UDP port.
        dst_port (int): Destination UDP port.

    Returns:
        None.  Prints a success/failure message.
    """

    # Create the Ethernet layer
    layer_2 = Ether(src=src_mac, dst=dst_mac)
    layer_3 = IP(src=src_ip, dst=dst_ip)
    layer_4 = UDP(sport=src_port, dport=dst_port)


    for i in range(ramp_size):
        load            = Raw (load = int(i))
        packet          = layer_2 / layer_3 / layer_4 / load  # Construct the packet
        original_size   = len(packet)
        target_size     = 60
        padding_needed  = target_size - original_size
        padding_bytes   = 'x' * padding_needed
        packet          = packet/ Raw(load=padding_bytes)

        try:
            sendp(packet, verbose=0)  # Send the packet.  verbose=0 suppresses verbose output.
            print(f"Ethernet packet sent successfully: {packet.summary()}")
        except Exception as e:
            print(f"Error sending packet: {e}")


if __name__ == "__main__":
    # Example usage:
    if len(sys.argv) != 10:
        print("Usage: ./send_udp_packet.py <command> <interface> <dst_mac> <src_mac> <dst_ip> <src_ip> <src_port> <dst_port> [data]")
        print("Example: ./send_udp_packet.py normal eno0 00:11:22:33:44:55 AA:BB:CC:DD:EE:FF 192.168.1.10 192.168.1.1 5000 8080")
        sys.exit(1)

    command     = sys.argv[1]
    interface   = sys.argv[2]
    dst_mac     = sys.argv[3]
    src_mac     = sys.argv[4]
    dst_ip      = sys.argv[5]
    src_ip      = sys.argv[6]
    src_port    = int(sys.argv[7])
    dst_port    = int(sys.argv[8])
    data        = sys.argv[9] if len(sys.argv) > 9 else ""

    try:
        from scapy.all import conf
        conf.iface = interface
    except ImportError:
        print("Scapy not installed, or could not import conf.iface. Please install Scapy and configure the interface.")
        sys.exit(1)

    if (command == "ramp") :
        send_udp_ramp(dst_mac, src_mac, dst_ip, src_ip, src_port, dst_port, int(payload))
    else:
        send_udp_ethernet(dst_mac, src_mac, dst_ip, src_ip, src_port, dst_port, data)
