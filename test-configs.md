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

## Operational commands for status
once the above configs are commmitted, the operational status can be viewed using the command `show interface routing'

```
root@acf436c2d929# run show interfaces routing
Interface        State Addresses
VX100            Up    ISO   enabled
                       MPLS  enabled
                       INET  10.10.1.1
                       INET6 fe80::cc32:8eff:fe69:8b98
```

if the interface is placed within VRF, then respective tables are created. In the below example, the VX100 interface was placed inside a VRF "TEST"

```
root@acf436c2d929# run show route table TEST.inet.0

TEST.inet.0: 2 destinations, 2 routes (2 active, 0 holddown, 0 hidden)
+ = Active Route, - = Last Active, * = Both

10.10.1.0/30       *[Direct/0] 00:00:10
                    >  via VX100
10.10.1.1/32       *[Local/0] 00:00:10
                       Local via VX100
```

since no forwarding table operational commands exist on cRPD, one can login to shell to view hte same. 

### View interface in shell
```
root@acf436c2d929:/# ifconfig VX100
VX100: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
        inet 10.10.1.1  netmask 255.255.255.252  broadcast 0.0.0.0
        inet6 fe80::cc32:8eff:fe69:8b98  prefixlen 64  scopeid 0x20<link>
        ether ce:32:8e:69:8b:98  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 15  bytes 1404 (1.4 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

### View route table in shell
```
root@acf436c2d929:/# ip route show
```

In case interface inside VRF, get the table number of VRF and look at the routes within the table. Notice the dev VX100 placed within VRF table.

```
root@acf436c2d929:/# ip vrf show
Name              Table
-----------------------
__crpd-vrf1          1

root@acf436c2d929:/# ip route show table 1
broadcast 10.10.1.0 dev VX100 proto kernel scope link src 10.10.1.1
10.10.1.0/30 dev VX100 proto kernel scope link src 10.10.1.1
local 10.10.1.1 dev VX100 proto kernel scope host src 10.10.1.1
broadcast 10.10.1.3 dev VX100 proto kernel scope link src 10.10.1.1
```
### View bridge output to ensure MAC learning has taken place over VTEP
```
root@acf436c2d929:/# bridge fdb show
33:33:00:00:00:01 dev __crpd-vrf1 self permanent
01:00:5e:00:00:01 dev __crpd-vrf1 self permanent
00:00:00:00:00:00 dev VX100 dst 10.1.1.1 self permanent
```
Notice that "00:00:00:00:00:00" is present in this output. Once there is ping/traffic across vtep, it will learn the far end vtep mac address and populate this table accordingly. 
 
