package leosatelliteenv;

import inet.linklayer.ppp.PppInterface;
import inet.mobility.base.MobilityBase;
import inet.physicallayer.wireless.ieee80211.packetlevel.Ieee80211ScalarRadio;
import inet.physicallayer.wireless.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import inet.networklayer.ipv4.Ipv4;
import inet.networklayer.ipv6.Ipv6;
import inet.networklayer.configurator.ipv4.Ipv4FlatNetworkConfigurator;
import inet.networklayer.configurator.ipv6.Ipv6FlatNetworkConfigurator;
import inet.node.inet.Router;
import inet.node.ipv6.Router6;
import inet.node.inet.StandardHost;
import inet.node.ipv6.StandardHost6;
import ned.DatarateChannel;

module Satellite
{

    parameters:
        int n;   // Number of clients
        string displayPosition = default("p=200,200");
        
    gates:
        input physi;
        output physo;
        inout pppg;
        
    types:
        channel fiberline extends DatarateChannel
        {
            delay = 1ms;
            datarate = 512Mbps;
        }
        channel satelliteChannel extends DatarateChannel
        {
            delay = 250ms; // higher delay typical for satellite links
            datarate = 50Mbps; // typical satellite link speed
        }

    submodules:
        configurator: Ipv4FlatNetworkConfigurator {
            @display("p=100,100;is=s");
        }
        r1: Router {
            @display("p=400,100");
        }
        r2: Router {
            @display("p=550,100");
        }
        r3: Router {
            @display("p=700,100");
        }
        cli[n]: StandardHost {
            @display("p=250,100,col,100");
        }
        srv: StandardHost {
            @display("p=850,100");
        }

    connections:
        for i=0..n-1 {
            cli[i].ethg++ <--> satelliteChannel <--> r1.ethg++;
        }
        r1.pppg++ <--> fiberline <--> r2.pppg++;
        r2.ethg++ <--> satelliteChannel <--> r3.ethg++;
        r3.pppg++ <--> fiberline <--> srv.pppg++;
}