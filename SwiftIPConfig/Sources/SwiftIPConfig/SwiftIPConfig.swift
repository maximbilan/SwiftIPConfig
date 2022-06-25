import gateway

public enum SwiftIPConfig {

    public static func getGatewayIP() -> String? {
        var gatewayaddr = in_addr()
        let r = getdefaultgateway(&gatewayaddr.s_addr)
        guard r >= 0 else {
            return nil
        }
        return String(cString: inet_ntoa(gatewayaddr))
    }

}
