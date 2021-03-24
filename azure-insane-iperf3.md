# Sample spoke to spoke iperf3 test

Instance size, location should be taken into account when making observations.
The results below were gathered in March 2021 in Azure.

### Azure Location 
**_East US_**

### Aviatrix Gateway size
**_Standard_D3_v2_**

### Test VM Kit
**_Standard_DS3_v2_**


Size |	vCPU |	Memory: GiB	| Temp storage (SSD) GiB |	Max data disks	| Max cached and temp storage throughput: IOPS/MBps (cache size in GiB)	| Max uncached disk throughput: IOPS/MBps |	Max NICs	| Expected network bandwidth (Mbps)
:--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :---   
Standard_DS3_v2 | 4 |	14	| 28 |	16 | 16000/128 (172) |	12800/192 | 	4 |	3000

[Azure Virtual Machine Sizing Documentation](https://docs.microsoft.com/en-us/azure/virtual-machines/dv2-dsv2-series)

```
iperf3 -s -p 5201 # on Spoke 1
iperf3 -c 10.24.1.4 -i 2 -t 30 -M 1400 -P 10 -p 5201 # on Spoke 2

- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec  1.44 GBytes   412 Mbits/sec  624             sender
[  4]   0.00-30.00  sec  1.44 GBytes   412 Mbits/sec                  receiver
[  6]   0.00-30.00  sec   182 MBytes  50.8 Mbits/sec  338             sender
[  6]   0.00-30.00  sec   181 MBytes  50.6 Mbits/sec                  receiver
[  8]   0.00-30.00  sec   508 MBytes   142 Mbits/sec  398             sender
[  8]   0.00-30.00  sec   507 MBytes   142 Mbits/sec                  receiver
[ 10]   0.00-30.00  sec   750 MBytes   210 Mbits/sec  667             sender
[ 10]   0.00-30.00  sec   749 MBytes   209 Mbits/sec                  receiver
[ 12]   0.00-30.00  sec   216 MBytes  60.4 Mbits/sec  290             sender
[ 12]   0.00-30.00  sec   215 MBytes  60.2 Mbits/sec                  receiver
[ 14]   0.00-30.00  sec  1.04 GBytes   298 Mbits/sec  412             sender
[ 14]   0.00-30.00  sec  1.04 GBytes   298 Mbits/sec                  receiver
[ 16]   0.00-30.00  sec  2.63 GBytes   752 Mbits/sec  174             sender
[ 16]   0.00-30.00  sec  2.62 GBytes   751 Mbits/sec                  receiver
[ 18]   0.00-30.00  sec  1.02 GBytes   291 Mbits/sec  688             sender
[ 18]   0.00-30.00  sec  1.02 GBytes   291 Mbits/sec                  receiver
[ 20]   0.00-30.00  sec   239 MBytes  66.9 Mbits/sec  111             sender
[ 20]   0.00-30.00  sec   238 MBytes  66.5 Mbits/sec                  receiver
[ 22]   0.00-30.00  sec   273 MBytes  76.3 Mbits/sec  283             sender
[ 22]   0.00-30.00  sec   272 MBytes  76.1 Mbits/sec                  receiver
[SUM]   0.00-30.00  sec  8.24 GBytes  2.36 Gbits/sec  3985             sender
[SUM]   0.00-30.00  sec  8.23 GBytes  2.36 Gbits/sec                  receiver

iperf Done.
```
