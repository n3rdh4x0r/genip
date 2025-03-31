#!/usr/bin/env python3
import ipaddress
import argparse
import sys

def generate_ip_range(ip_range):
    try:
        start_ip, end_num = ip_range.split('-')
        start = ipaddress.IPv4Address(start_ip)
        
        # Handle cases like 192.168.1.1-80 (last octet only)
        if '.' not in end_num:
            base = '.'.join(start_ip.split('.')[:-1])
            end_ip = f"{base}.{end_num}"
        else:
            end_ip = end_num
            
        end = ipaddress.IPv4Address(end_ip)
        
        if start > end:
            start, end = end, start
            
        return [str(start + i) for i in range(int(end) - int(start) + 1)]
        
    except (ValueError, AttributeError) as e:
        print(f"Error: Invalid IP range format. Use format like '192.168.1.1-80' or '192.168.1.1-192.168.1.80'")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description='Generate IP list from range and save to file')
    parser.add_argument('ip_range', help='IP range (e.g., 192.168.1.1-80 or 192.168.1.1-192.168.1.80)')
    parser.add_argument('-o', '--output', required=True, help='Output file name (required)')
    
    args = parser.parse_args()
    
    ip_list = generate_ip_range(args.ip_range)
    
    with open(args.output, 'w') as f:
        for ip in ip_list:
            f.write(ip + '\n')
    
    print(f"Generated {len(ip_list)} IPs and saved to {args.output}")

if __name__ == '__main__':
    main()
