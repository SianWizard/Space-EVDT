function [vect1_rsw,vect2_rsw,vect3_rsw] = ECI2RSW_vect(x,y,z,vx,vy,vz,vect1,vect2,vect3)

normR= sqrt(x.^2+y.^2+z.^2);

Rx=x./normR;
Ry=y./normR;
Rz=z./normR;

crossRVx=y.*vz-z.*vy;
crossRVy=z.*vx-x.*vz;
crossRVz=x.*vy-y.*vx;

normW= sqrt(crossRVx.^2+crossRVy.^2+crossRVz.^2);

Wx=crossRVx./normW;
Wy=crossRVy./normW;
Wz=crossRVz./normW;

Sx=Wy.*Rz-Wz.*Ry;
Sy=Wz.*Rx-Wx.*Rz;
Sz=Wx.*Ry-Wy.*Rx;

vect1_rsw=Rx.*vect1+Ry.*vect2+Rz.*vect3;
vect2_rsw=Sx.*vect1+Sy.*vect2+Sz.*vect3;
vect3_rsw=Wx.*vect1+Wy.*vect2+Wz.*vect3;

