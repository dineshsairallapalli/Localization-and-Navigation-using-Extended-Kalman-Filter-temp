function [covarEst,uEst] = pred_step(uPrev,covarPrev,angVel,acc,dt)
%covarPrev and uPrev are the previous mean and covariance respectively
%angVel is the angular velocity
%acc is the acceleration
%dt is the sampling time
%uPrev is the given state values


x = uPrev(7,1);
y = uPrev(8,1);
z = uPrev(9,1);

roll_imu = uPrev(4,1);
pitch_imu = uPrev(5,1);
yaw_imu = uPrev(6,1);

xb = uPrev(10,1);
yb = uPrev(11,1);
zb = uPrev(12,1);

xa = uPrev(13,1);
ya = uPrev(14,1);
za = uPrev(15,1);

mx = angVel(1,1);
my = angVel(2,1);
mz = angVel(3,1);

accx = acc(1,1);
accy = acc(2,1);
accz = acc(3,1);


x_dot = [x; y; z; ((sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu))*(zb - mz) - ((sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu))*(yb - my) - (xb - mx)*(cos(yaw_imu)^2 + sin(yaw_imu)^2); (zb - mz)*(cos(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + sin(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu))) - (yb - my)*(cos(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) + sin(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu))); - (zb - mz)*(cos(pitch_imu)*cos(roll_imu) + (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu) - (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu)) - (yb - my)*(cos(pitch_imu)*sin(roll_imu) - (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) + (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu)) - (xb - mx)*(sin(pitch_imu)*cos(yaw_imu)^2 + sin(pitch_imu)*sin(yaw_imu)^2 - sin(pitch_imu)); (accz - za)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)) - (accy - ya)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)) + cos(pitch_imu)*cos(yaw_imu)*(accx - xa); (accy - ya)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - (accz - za)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + cos(pitch_imu)*sin(yaw_imu)*(accx - xa); cos(pitch_imu)*cos(roll_imu)*(accz - za) - sin(pitch_imu)*(accx - xa) + cos(pitch_imu)*sin(roll_imu)*(accy - ya) - (981/100); (0); (0); (0); (0); (0); (0)];

uEst  = uPrev + dt* x_dot;
    

ta = [(0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0), (0), (0); (0), (0), (0), ((sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu))*(yb - my) + ((sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu))*(zb - mz), - (zb - mz)*(cos(roll_imu)*cos(yaw_imu)^2 + cos(roll_imu)*sin(yaw_imu)^2 + (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu)^2 - (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu)^2) - (yb - my)*(cos(yaw_imu)^2*sin(roll_imu) + sin(roll_imu)*sin(yaw_imu)^2 - (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu)^2 + (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu)^2), (0), (0), (0), (0), - cos(yaw_imu)^2 - sin(yaw_imu)^2, (cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) - (sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu), ((sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu)), (0), (0), (0); (0), (0), (0), (yb - my)*(cos(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + sin(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu))) + (zb - mz)*(cos(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) + sin(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu))), (0), (0), (0), (0), (0), (0), - cos(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - sin(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), (cos(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + sin(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu))), (0), (0), (0); (0), (0), (0), (zb - mz)*(cos(pitch_imu)*sin(roll_imu) - (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) + (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu)) - (yb - my)*(cos(pitch_imu)*cos(roll_imu) + (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu) - (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu)), - (zb - mz)*(cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)) - cos(roll_imu)*sin(pitch_imu) - sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + cos(roll_imu)*cos(yaw_imu)^2*sin(pitch_imu) + cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)^2 + (cos(yaw_imu)*sin(pitch_imu)^2*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu)^2 - (sin(pitch_imu)^2*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu)^2) - (yb - my)*(sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)) - sin(pitch_imu)*sin(roll_imu) + cos(yaw_imu)^2*sin(pitch_imu)*sin(roll_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)^2 - (cos(yaw_imu)*sin(pitch_imu)^2*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu)^2 + (sin(pitch_imu)^2*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu)^2) - (xb - mx)*(cos(pitch_imu)*cos(yaw_imu)^2 + cos(pitch_imu)*sin(yaw_imu)^2 - cos(pitch_imu)), (0), (0), (0), (0), - sin(pitch_imu)*cos(yaw_imu)^2 - sin(pitch_imu)*sin(yaw_imu)^2 + sin(pitch_imu), (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) - cos(pitch_imu)*sin(roll_imu) - (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu), (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu) - cos(pitch_imu)*cos(roll_imu), (0), (0), (0); (0), (0), (0), (accy - ya)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)) + (accz - za)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), cos(pitch_imu)*cos(roll_imu)*cos(yaw_imu)*(accz - za) - cos(yaw_imu)*sin(pitch_imu)*(accx - xa) + cos(pitch_imu)*cos(yaw_imu)*sin(roll_imu)*(accy - ya), (accz - za)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) - (accy - ya)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - cos(pitch_imu)*sin(yaw_imu)*(accx - xa), (0), (0), (0), (0), (0), (0), -cos(pitch_imu)*cos(yaw_imu), (cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), - sin(roll_imu)*sin(yaw_imu) - cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu); (0), (0), (0), - (accy - ya)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) - (accz - za)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)), cos(pitch_imu)*cos(roll_imu)*sin(yaw_imu)*(accz - za) - sin(pitch_imu)*sin(yaw_imu)*(accx - xa) + cos(pitch_imu)*sin(roll_imu)*sin(yaw_imu)*(accy - ya), (accz - za)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)) - (accy - ya)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)) + cos(pitch_imu)*cos(yaw_imu)*(accx - xa), (0), (0), (0), (0), (0), (0), -cos(pitch_imu)*sin(yaw_imu), - cos(roll_imu)*cos(yaw_imu) - sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu), (cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)); (0), (0), (0), cos(pitch_imu)*cos(roll_imu)*(accy - ya) - cos(pitch_imu)*sin(roll_imu)*(accz - za), - cos(pitch_imu)*(accx - xa) - cos(roll_imu)*sin(pitch_imu)*(accz - za) - sin(pitch_imu)*sin(roll_imu)*(accy - ya), (0), (0), (0), (0), (0), (0), (0), sin(pitch_imu), -cos(pitch_imu)*sin(roll_imu), -cos(pitch_imu)*cos(roll_imu); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0)];

tf = eye(15,15) + dt* ta;

tu = [(0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); - cos(yaw_imu)^2 - sin(yaw_imu)^2, (cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) - (sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu), (sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), - cos(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - sin(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), cos(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + sin(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)), (0), (0), (0), (0), (0), (0), (0), (0), (0); - sin(pitch_imu)*cos(yaw_imu)^2 - sin(pitch_imu)*sin(yaw_imu)^2 + sin(pitch_imu), (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) - cos(pitch_imu)*sin(roll_imu) - (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu), (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu) - cos(pitch_imu)*cos(roll_imu), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), -cos(pitch_imu)*cos(yaw_imu), (cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), - sin(roll_imu)*sin(yaw_imu) - cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu), (0), (0), (0), (0), (0), (0); (0), (0), (0), -cos(pitch_imu)*sin(yaw_imu), - cos(roll_imu)*cos(yaw_imu) - sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu), (cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)), (0), (0), (0), (0), (0), (0); (0), (0), (0), sin(pitch_imu), -cos(pitch_imu)*sin(roll_imu), -cos(pitch_imu)*cos(roll_imu), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (1), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (1), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (1), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (1)];

V  = tu;
Q = eye(12,12) * dt;

covarEst = tf* covarPrev * (tf)' + V* Q * V';
    
end