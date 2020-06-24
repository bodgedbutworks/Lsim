/// @brief Class for storing and calculating moving lights angular position, speed and acceleration (single axis)
class Dynamics {
  String name = "Axis";
  int angle = 180;                                                              // [deg]
  int offset = 0;                                                               // [deg]
  int chanCoarse = 1;
  int chanFine = 2;

  int state = 0;                                                                // 0=idle, 1=accelerating, 2=@maxSpeed, 3=decelerating, 4=tweaking

  // ToDo add pan/tilt angles here and constrain pos to those
  // ToDo sometimes the fixtures start spinning endlessly, find out why
  float maxAcc = 0.18;
  float maxSpd = 6.0;
  float maxSpdTweak = 0.1;

  float dest = 0;                                                               // Destination (Angular value [deg])
  float pos = 0;                                                                // Current position [deg]
  float spd = 0;                                                                // Current speed [deg/frame]
  float acc = 0;                                                                // Current acceleration, constant (always 0 or +/- maxAcc)

  Dynamics(String iName) {
    name = iName;
  }

  /// @brief Update the destination angle
  /// @param iFixtureAddress DMX address of the corresponding Fixture
  /// @param iDmxUniverse DMX Data in the corresponding Fixture's universe
  /// @return
  void updateDest(int iFixtureAddress, byte[] iDmxUniverse) {
    if (chanCoarse > 0) {                                                       // If Fixture has this movement capability
      int msb = ((chanCoarse>0) ? int(iDmxUniverse[constrain(iFixtureAddress-1+chanCoarse-1, 0, 511)]) : 127);
      int lsb = ((chanFine>0) ? int(iDmxUniverse[constrain(iFixtureAddress-1+chanFine-1, 0, 511)]) : 127);
      float tempDest = ((msb<<8) | lsb)*float(angle)/65536.0 + offset;
      if (dest != tempDest) {                                                   // Check for changes, if so: reset state
        dest = tempDest;
        state = 0;
      }
      move();
    } else {
      pos = float(angle)/2 + offset;
    }
  }


  // ToDo Debug movements with many updates (e.g. EFX)

  /// @brief Perform smooth movement towards destination
  void move() {
    float diff = dest - pos;

    /* print(diff);
     print(" ");
     print(state);
     print(" ");
     print(acc);
     print(" ");
     print(spd);
     print(" ");
     println(); */

    // ifs instead of switch/case so that multiple state changes can be handled in one function call
    if (state == 0) {
      if (abs(diff) < POS_TOLERANCE) {            // While within tolerance
        acc = 0;
        spd = 0;
      } else {
        acc = ((diff>=0) ? maxAcc : -maxAcc);     // Set acc to constant value (+/-)
        state = 1;
      }
    }
    if (state == 1) {
      float lookahead_spd = spd+acc;              // Estimate theoretical speed in the next iteration
      float lookahead_pos = diff-spd;             // Estimate theoretical pos in the next iteration
      // If either max spd reached OR it's already time to decelerate
      if ((abs(spd) >= maxSpd)  ||  ((lookahead_spd*lookahead_spd)/(2*maxAcc)) >= abs(lookahead_pos)) {
        spd = constrain(spd, -maxSpd, maxSpd);
        state = 2;
      } else {
        spd += acc;
      }
    }
    if (state == 2) {
      if (((spd*spd)/(2*maxAcc)) >= abs(diff)) {    // Check if it's time to decelerate
        state = 3;
      }
    }
    if (state == 3) {       // ToDo: If dest pos is changed by a small amount in reverse direction during deceleration, the speed jumps to zero
      spd -= acc;
      if (spd*diff < 0) {    // When the speed=0 point is passed (spd points in opposite direction of diff)
        spd = ((diff>=0) ? maxSpdTweak : -maxSpdTweak);
        state = 4;
      }
    }
    if (state == 4) {
      if (abs(diff) >= POS_TOLERANCE) {
        /* Tweak with small spd (set in state no. 3) */
      } else {
        state = 0;
      }
    }

    pos += spd;
  }

  /// @brief Load this Dynamic's GUI Elements
  /// @return This Dynamic's GUI Elements inside an Expendable
  Expandable returnGui() {
    Expandable dynamicsExp = new Expandable(new PVector(0, 0), new PVector(0, 0), name, true, false, CLR_MENU_LV2);
    dynamicsExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Channel Coarse", "Channel Coarse", chanCoarse, 1, 0, 512, 0));
    dynamicsExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Channel Fine", "Channel Fine", chanFine, 1, 0, 512, 0));
    dynamicsExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Angle", "Total Angle", angle, 1, 90, 720, -1));
    dynamicsExp.put(new IntBox(new PVector(10, 0), new PVector(80, 25), this, "Offset", "Angular Offset", offset, 1, -180, 180, -999));
    dynamicsExp.put(new SpinBox(new PVector(10, 0), new PVector(80, 25), this, "Accel", "Max Accel", maxAcc, 0.01));
    dynamicsExp.put(new SpinBox(new PVector(10, 0), new PVector(80, 25), this, "Speed", "Max Speed", maxSpd, 0.01));
    dynamicsExp.put(new SpinBox(new PVector(10, 0), new PVector(80, 25), this, "Tweak", "Tweak Speed", maxSpdTweak, 0.01));
    return(dynamicsExp);
  }

  /// @brief Pack relevant attributes into a JSON and return it
  /// @return JSON data with this object's saved attributes
  JSONObject save() {
    JSONObject oJson = new JSONObject();
    oJson.setInt("chanCoarse", chanCoarse);
    oJson.setInt("chanFine", chanFine);
    oJson.setInt("angle", angle);
    oJson.setFloat("offset", offset);
    oJson.setFloat("maxAcc", maxAcc);
    oJson.setFloat("maxSpd", maxSpd);
    oJson.setFloat("maxSpdTweak", maxSpdTweak);
    return(oJson);
  }

  /// @brief Load object attributes from provided JSON Data
  /// @param iJson JSON Dataset including this object's attributes to load
  void load(JSONObject iJson) {
    chanCoarse = iJson.getInt("chanCoarse");
    chanFine = iJson.getInt("chanFine");
    angle = iJson.getInt("angle");
    offset = iJson.getInt("offset");
    maxAcc = iJson.getFloat("maxAcc");
    maxSpd = iJson.getFloat("maxSpd");
    maxSpdTweak = iJson.getFloat("maxSpdTweak");
    print("Loading Dynamics..");
  }
}
