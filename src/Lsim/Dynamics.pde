class Dynamics {
  int state = 0;    // 0=idle, 1=accelerating, 2=@maxSpeed, 3=decelerating, 4=tweaking

  // ToDo add pan/tilt angles here and constrain pos to those
  // ToDo sometimes the fixtures start spinning endlessly, find out why
  float maxAcc = 0.18;
  float maxSpd = 6.0;
  float maxSpdTweak = 0.1;

  float dest = 0;                      // Destination (Angular value [deg])
  float pos = 0;                       // Current position [deg]
  float spd = 0;                       // Current speed [deg/frame]
  float acc = 0;                       // Current acceleration, constant (always 0 or +/- maxAcc)

  void updateDest(float iDest) {       // Check for changes, if so: reset state
    float tempDest = iDest;
    if (dest != tempDest) {
      dest = tempDest;
      state = 0;
    }
  }

  // ToDo Debug movements with many updates (e.g. EFX)
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

  String getSaveString() {
    return(
      str(maxAcc) + ";" +
      str(maxSpd) + ";" +
      str(maxSpdTweak)
      );
  }

  void setLoadArray(String[] iProps) {
    try {
      maxAcc = float(iProps[0]);
      maxSpd = float(iProps[1]);
      maxSpdTweak = float(iProps[2]);
      print("Loading Dynamics..");
    } 
    catch(Exception e) {
      println(e);
    }
  }
}
