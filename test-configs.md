# Example configuration and test cases
Below are some of the examples to configure unicast vxlan tunnel on linux VMs/servers using cRPD. Note that these are also exposed via netconf and hence one car use netconf to program these interfaces on cRPD  

## Add single tunnel in a single commit
```
set unicast-vxlan:vxlan interface VX100 interface eth0
set unicast-vxlan:vxlan interface VX100 ip-prefix 10.10.1.1/30
set unicast-vxlan:vxlan interface VX100 remote-ip 10.1.1.1
set unicast-vxlan:vxlan interface VX100 destination-port 4788
set unicast-vxlan:vxlan interface VX100 vni 100
```
## Add multiple tunnels in a single commit 
```
set unicast-vxlan:vxlan interface VX100 interface eth0
set unicast-vxlan:vxlan interface VX100 ip-prefix 10.10.1.1/30
set unicast-vxlan:vxlan interface VX100 remote-ip 10.1.1.1
set unicast-vxlan:vxlan interface VX100 destination-port 4788
set unicast-vxlan:vxlan interface VX100 vni 100

set unicast-vxlan:vxlan interface VX200 interface eth0
set unicast-vxlan:vxlan interface VX200 ip-prefix 20.1.1.1/30
set unicast-vxlan:vxlan interface VX200 remote-ip 20.10.1.1
set unicast-vxlan:vxlan interface VX200 destination-port 4888
set unicast-vxlan:vxlan interface VX200 vni 200

set unicast-vxlan:vxlan interface VX300 interface eth0
set unicast-vxlan:vxlan interface VX300 ip-prefix 30.1.1.1/30
set unicast-vxlan:vxlan interface VX300 remote-ip 30.10.1.1
set unicast-vxlan:vxlan interface VX300 destination-port 4889
set unicast-vxlan:vxlan interface VX300 vni 300
```

## Delete single tunnel 
```
delete unicast-vxlan:vxlan interface VX100 
```

## Delete multiple tunnels
```
delete unicast-vxlan:vxlan interface VX100 
delete unicast-vxlan:vxlan interface VX200 
delete unicast-vxlan:vxlan interface VX300 
```

### Delete all tunnels from top level
```
delete unicast-vxlan:vxlan
```

## Add single tunnel along with Routing instance
``` 
set routing-instances test instance-type vrf
set routing-instances test interface VX200
set routing-instances test route-distinguisher 100:100
set routing-instances test vrf-target target:100:100
set routing-instances test vrf-table-label

set unicast-vxlan:vxlan interface VX200 interface eth0
set unicast-vxlan:vxlan interface VX200 ip-prefix 20.1.1.1/30
set unicast-vxlan:vxlan interface VX200 remote-ip 20.10.1.1
set unicast-vxlan:vxlan interface VX200 destination-port 4888
set unicast-vxlan:vxlan interface VX200 vni 200
```

## Add single tunnel with routing instance and remaining tunnels outside of RI
```
set routing-instances test instance-type vrf
set routing-instances test interface VX200
set routing-instances test route-distinguisher 100:100
set routing-instances test vrf-target target:100:100
set routing-instances test vrf-table-label

set unicast-vxlan:vxlan interface VX200 interface eth0
set unicast-vxlan:vxlan interface VX200 ip-prefix 20.1.1.1/30
set unicast-vxlan:vxlan interface VX200 remote-ip 20.10.1.1
set unicast-vxlan:vxlan interface VX200 destination-port 4888
set unicast-vxlan:vxlan interface VX200 vni 200

set unicast-vxlan:vxlan interface VX100 interface eth0
set unicast-vxlan:vxlan interface VX100 ip-prefix 10.10.1.1/30
set unicast-vxlan:vxlan interface VX100 remote-ip 10.1.1.1
set unicast-vxlan:vxlan interface VX100 destination-port 4788
set unicast-vxlan:vxlan interface VX100 vni 100

set unicast-vxlan:vxlan interface VX300 interface eth0
set unicast-vxlan:vxlan interface VX300 ip-prefix 30.1.1.1/30
set unicast-vxlan:vxlan interface VX300 remote-ip 30.10.1.1
set unicast-vxlan:vxlan interface VX300 destination-port 4889
set unicast-vxlan:vxlan interface VX300 vni 300
```

## Establish BGP over VXLAN tunnel interface within a VRF
```
set routing-instances TEST instance-type vrf
set routing-instances TEST protocols bgp group TEST type internal
set routing-instances TEST protocols bgp group TEST neighbor 40.1.1.1 family inet unicast
set routing-instances TEST interface VX-BGP
set routing-instances TEST route-distinguisher 100:100
set routing-instances TEST vrf-target target:100:100
set routing-instances TEST vrf-table-label
set routing-instances TEST protocols bgp local-as 10

set unicast-vxlan:vxlan interface VX-BGP interface eth0
set unicast-vxlan:vxlan interface VX-BGP ip-prefix 40.1.1.2/30
set unicast-vxlan:vxlan interface VX-BGP remote-ip 16.1.1.1
set unicast-vxlan:vxlan interface VX-BGP destination-port 5555
set unicast-vxlan:vxlan interface VX-BGP vni 400
```

