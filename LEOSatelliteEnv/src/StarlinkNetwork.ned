package leosatelliteenv;

import inet.networklayer.configurator.ipv4.Ipv4FlatNetworkConfigurator;
import inet.node.inet.Router;
import inet.node.inet.WirelessHost;
import inet.physicallayer.wireless.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;

channel DatarateChannel extends ned.DatarateChannel {
    delay = 10ms;  // Customize as needed
    datarate = 1Gbps;  // Customize as needed
}

network StarlinkNetwork
{
    parameters:
        int numSatellites = default(16); // Total satellites
        int numPlanes = default(4);     // Orbital planes
        int clusterSize = default(2);   // Satellites per cluster
        int numGroundStations;          // Ground stations
        int numPoPs;                    // Points of Presence

    submodules:
        init: InitialisationModule {
            parameters:
                numPlanes = numPlanes;
                clusterSize = clusterSize;
                numSatellites = numSatellites;
                @display("p=417,47");
        }
        
        configurator: Ipv4FlatNetworkConfigurator {
            @display("p=100,100");
        }

        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=200,100");
        }

        satellite[numSatellites]: Satellite {
            @display("i=device/satellite;is=s");
        }

        groundStation[numGroundStations]: Router {
            @display("i=device/server;is=s");
        }

        pop[numPoPs]: Router {
            @display("i=device/cloud;is=s");
        }

    connections allowunconnected:
        // Inter-plane connections (loop across planes)
        for i=0..numSatellites-1 {
            satellite[i].pppg <--> DatarateChannel <--> satellite[(i + clusterSize) % numSatellites].pppg;
        }
    
        // Ground links (Ground Stations to PoPs)
        for i=0..numGroundStations-1 {
            groundStation[i].pppg++ <--> pop[i % numPoPs].pppg++;
        }

}