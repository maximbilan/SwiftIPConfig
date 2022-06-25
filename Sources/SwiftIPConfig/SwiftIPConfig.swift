import Foundation
import gateway

public enum SwiftIPConfig {

    /// Returns local IP address. For example: "192.168.1.34"
    /// - Returns: String or nil
    public static func getIP(ethernet: String = "en0") -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }

        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }

            guard let interface = ptr?.pointee else {
                return nil
            }

            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                guard let ifa_name = interface.ifa_name else {
                    return nil
                }
                let name: String = String(cString: ifa_name)
                if name == ethernet {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }

    /// Returns Gateway IP. A gateway IP refers to a device on a network which sends local network traffic to other networks. For example: "192.168.1.1"
    /// - Returns: Returns: String or nil
    public static func getGatewayIP() -> String? {
        var gatewayaddr = in_addr()
        let result = get_gateway(&gatewayaddr.s_addr)
        guard result >= 0 else {
            return nil
        }
        return String(cString: inet_ntoa(gatewayaddr))
    }

    /// Returns Netmask. Netmasks (or subnet masks) are a shorthand for referring to ranges of consecutive IP addresses in the Internet Protocol. For example: "255.255.255.0"
    /// - Returns: Returns: String or nil
    public static func getNetmask(ethernet: String = "en0") -> String? {
        var netmask: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil

        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }

        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }

            guard let interface = ptr?.pointee else {
                return nil
            }

            let name = String(utf8String: interface.ifa_name)
            guard name == ethernet else {
                return nil
            }

            var addr = interface.ifa_addr.pointee
            guard addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) else {
                return nil
            }

            let flags = Int32(interface.ifa_flags)
            guard (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) else {
                return nil
            }

            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            guard getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0 else {
                return nil
            }

            var net = interface.ifa_netmask.pointee
            var netmaskName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(&net, socklen_t(net.sa_len), &netmaskName, socklen_t(netmaskName.count), nil, socklen_t(0), NI_NUMERICHOST)
            netmask = String(validatingUTF8: netmaskName)
        }
        freeifaddrs(ifaddr)

        return netmask
    }

}
