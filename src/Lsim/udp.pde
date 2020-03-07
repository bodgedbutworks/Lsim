/*
sendUdp(){
 String message = "lol rofl";
 udp.send(message, "localhost", 6454);
 }
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
    /*
    for(int i=8; i<30; i++){
     print(int(iData[i]));
     print(".");
     }
     println();
     */
    //println("receive: \"" + str(subset(iData, 0, 10)) + "\" from " + iIp + " on port " + iPort);
  } else {
    println("(Packet of wrong length received)");
  }
}
