
byte[] artnetHeader = {'A', 'r', 't', '-', 'N', 'e', 't', '\0'};
byte[][] dmxData = new byte[4][512];                                            // [universe][address]

/**
 * @brief Called upon UDP packet receival, checks for presence of ArtNet header and writes to dmxData
 * @param iData : The packet's contents
 * @param iIp : The sender's IP address
 * @param iPort : The receiving UDP port (ArtNet standard: 6454)
 */
void receive(byte[] iData, String iIp, int iPort) {
  if (iData.length == 530) {                                                      // ArtNet header + 512 bytes
    for (int i=0; i<8; i++) {
      if (iData[i] != artnetHeader[i]) {                                          // First 8 bytes must match header
        print("! ArtNet header mismatch !");
        return;
      }
    }
    int universe = iData[15]<<8 | iData[14];
    if (universe >= 0  &&  universe <= 3) {
      dmxData[universe] = subset(iData, 18, 512);
    }

  } else {
    //println("(Packet of wrong length received)");
  }
}
