// Transform _vector to sphere coordinates, modify them, then tranform back to cartesian & save to vector
// r = radius, omega = [0°-180°], phi = [0°-360°]
// Note: {+x, +y, +z} in sphere coordinates correspond to {+z, +x, -y}
void addSphereCoords(PVector _vector, float add_r, float add_omega, float add_phi) {
  PVector sphereCoords = new PVector(0, 0, 0);

  // Transform cartesian Processing coordinates to cartesian coordinates as defined for sphere
  sphereCoords.x = _vector.z;
  sphereCoords.y = _vector.x;
  sphereCoords.z = -(_vector.y);

  float old_r = sqrt(sq(sphereCoords.x) + sq(sphereCoords.y) + sq(sphereCoords.z));
  float old_omega = acos(sphereCoords.z/old_r);
  float old_phi = atan2(sphereCoords.y, sphereCoords.x);

  float new_r = old_r + add_r;
  float new_omega = old_omega;
  if ((old_omega+add_omega) < PI  &&  (old_omega+add_omega) > 0) {  // Exact values 0 and PI lead to display errors
    new_omega = old_omega + add_omega;
  }
  float new_phi = old_phi + add_phi;

  sphereCoords.x = new_r*sin(new_omega)*cos(new_phi);
  sphereCoords.y = new_r*sin(new_omega)*sin(new_phi);
  sphereCoords.z = new_r*cos(new_omega);

  // Transform cartesian coordinates as defined for sphere to cartesian Processing coordinates and save to vector
  _vector.x = sphereCoords.y;
  _vector.y = -(sphereCoords.z);
  _vector.z = sphereCoords.x;
}



// Note: Use PVector built-in function PVector.cross(v1, v2, target)
//PVector Kreuzprodukt(PVector vA, PVector vB) {
//  return new PVector(vA.y*vB.z-vA.z*vB.y, vA.z*vB.x-vA.x*vB.z, vA.x*vB.y-vA.y*vB.x);
//}



PVector rotateVector(PVector _oldVector, float _rotX, float _rotY, float _rotZ) {  //For KOSY to KOSY rotation
  PVector newVector = new PVector(0, 0, 0);

  float cx = cos(radians(_rotX));
  float cy = cos(radians(_rotY));
  float cz = cos(radians(_rotZ));

  float sx = sin(radians(_rotX));
  float sy = sin(radians(_rotY));
  float sz = sin(radians(_rotZ));

  newVector.x =          (cz*cy)*_oldVector.x +          (sz*cy)*_oldVector.y +   (-sy)*_oldVector.z;
  newVector.y = (cz*sy*sx-sz*cx)*_oldVector.x + (sz*sy*sx+cz*cx)*_oldVector.y + (cy*sx)*_oldVector.z;
  newVector.z = (cz*sy*cx-sz*sx)*_oldVector.x + (sz*sy*cx-cz*sx)*_oldVector.y + (cy*cx)*_oldVector.z;

  return(newVector);
}
