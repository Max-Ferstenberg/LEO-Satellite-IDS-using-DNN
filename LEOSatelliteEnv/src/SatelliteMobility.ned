package leosatelliteenv;

import inet.mobility.base.MobilityBase;

module SatelliteMobility
{
    parameters:
        string satelliteType = default("LEO");
        double altitude = default(1000);  // Default altitude
		int initialX = 500;
        int initialY = 500;
        int initialZ = altitude;
    gates:
        input in;
        output out;

    submodules:
        mobilityBase: MobilityBase {
            parameters:
                @display("p=100,100;is=s");
        }
}