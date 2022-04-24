/// @brief Transforms a vector to sphere coordinates, modifies them as requested,
///        then tranforms back to cartesian & returns the vector
/// @details r = radius, omega = [0°-180°], phi = [0°-360°]
/// @details Note: {+x, +y, +z} in sphere coordinates correspond to {+z, +x, -y}
/// @param iVector A PVector Object representing x, y, z position in 3D space
/// @param iAdd_r Radius to add
/// @param iAdd_omega Inclination to add [radians]
/// @param iAdd_phi Angle in horizontal plane to add [radians]
/// @return Modified PVector
PVector addSphereCoords(PVector iVector, float iAdd_r, float iAdd_omega, float iAdd_phi) {
  PVector sphereCoords = new PVector(0, 0, 0);

  // Transform cartesian Processing coordinates to cartesian coordinates as defined for sphere
  sphereCoords.x = iVector.z;
  sphereCoords.y = iVector.x;
  sphereCoords.z = -(iVector.y);

  float old_r = sqrt(sq(sphereCoords.x) + sq(sphereCoords.y) + sq(sphereCoords.z));
  float old_omega = acos(sphereCoords.z/old_r);
  float old_phi = atan2(sphereCoords.y, sphereCoords.x);

  float new_r = old_r + iAdd_r;
  float new_omega = old_omega;
  if ((old_omega+iAdd_omega) < PI  &&  (old_omega+iAdd_omega) > 0) {  // Exact values 0 and PI lead to display errors
    new_omega = old_omega + iAdd_omega;
  }
  float new_phi = old_phi + iAdd_phi;

  sphereCoords.x = new_r*sin(new_omega)*cos(new_phi);
  sphereCoords.y = new_r*sin(new_omega)*sin(new_phi);
  sphereCoords.z = new_r*cos(new_omega);

  // Cartesian coordinates as defined for sphere, transformed to cartesian Processing coordinates
  return(new PVector(sphereCoords.y, -(sphereCoords.z), sphereCoords.x));
}

/// @brief Rotates a vector by 3 angles (around x, y and z axis)
/// @dteails Useful for coordinate system to coordinate system transformations
/// @param iOldVector A PVector Object
/// @param iRot_x Rotation angle around x axis [degrees]
/// @param iRot_y Rotation angle around y axis [degrees]
/// @param iRot_z Rotation angle around z axis [degrees]
/// @return Rotated PVector
PVector rotateVector(PVector iOldVector, float iRot_x, float iRot_y, float iRot_z) {
  PVector newVector = new PVector(0, 0, 0);

  float cx = cos(radians(iRot_x));
  float cy = cos(radians(iRot_y));
  float cz = cos(radians(iRot_z));

  float sx = sin(radians(iRot_x));
  float sy = sin(radians(iRot_y));
  float sz = sin(radians(iRot_z));

  newVector.x =          (cz*cy)*iOldVector.x +          (sz*cy)*iOldVector.y +   (-sy)*iOldVector.z;
  newVector.y = (cz*sy*sx-sz*cx)*iOldVector.x + (sz*sy*sx+cz*cx)*iOldVector.y + (cy*sx)*iOldVector.z;
  newVector.z = (cz*sy*cx-sz*sx)*iOldVector.x + (sz*sy*cx-cz*sx)*iOldVector.y + (cy*cx)*iOldVector.z;

  return(newVector);
}
