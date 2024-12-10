 function [covarEst,uEst] = pred_step(uPrev,covarPrev,angVel,acc,dt)
%covarPrev and uPrev are the previous mean and covariance respectively
%angVel is the angular velocity
%acc is the accelertAion
%dt is the sampling time

x = uPrev(7,1);
y = uPrev(8,1);
z = uPrev(9,1);

roll_imu = uPrev(4,1);
pitch_imu = uPrev(5,1);
yaw_imu = uPrev(6,1);

bx = uPrev(10,1);
by = uPrev(11,1);
bz = uPrev(12,1);

xa = uPrev(13,1);
ya = uPrev(14,1);
za = uPrev(15,1);

mx = angVel(1,1);
my = angVel(2,1);
mz = angVel(3,1);

mxa = acc(1,1);
mya = acc(2,1);
mza = acc(3,1);


x_dot = [x; y; z; ((sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu))*(bz - mz) - ((sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu))*(by - my) - (bx - mx)*(cos(yaw_imu)^2 + sin(yaw_imu)^2); (bz - mz)*(cos(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + sin(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu))) - (by - my)*(cos(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) + sin(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu))); - (bz - mz)*(cos(pitch_imu)*cos(roll_imu) + (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu) - (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu)) - (by - my)*(cos(pitch_imu)*sin(roll_imu) - (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) + (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu)) - (bx - mx)*(sin(pitch_imu)*cos(yaw_imu)^2 + sin(pitch_imu)*sin(yaw_imu)^2 - sin(pitch_imu)); (mza - za)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)) - (mya - ya)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)) + cos(pitch_imu)*cos(yaw_imu)*(mxa - xa); (mya - ya)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - (mza - za)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + cos(pitch_imu)*sin(yaw_imu)*(mxa - xa); cos(pitch_imu)*cos(roll_imu)*(mza - za) - sin(pitch_imu)*(mxa - xa) + cos(pitch_imu)*sin(roll_imu)*(mya - ya) - (981/100); (0); (0); (0); (0); (0); (0)];

uEst  = uPrev + dt* x_dot;


tA = [(0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0), (0), (0); (0), (0), (0), ((sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu))*(by - my) + ((sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu))*(bz - mz), - (bz - mz)*(cos(roll_imu)*cos(yaw_imu)^2 + cos(roll_imu)*sin(yaw_imu)^2 + (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu)^2 - (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu)^2) - (by - my)*(cos(yaw_imu)^2*sin(roll_imu) + sin(roll_imu)*sin(yaw_imu)^2 - (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu)^2 + (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu)^2), (0), (0), (0), (0), - cos(yaw_imu)^2 - sin(yaw_imu)^2, (cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) - (sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu), ((sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu)), (0), (0), (0); (0), (0), (0), (by - my)*(cos(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + sin(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu))) + (bz - mz)*(cos(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) + sin(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu))), (0), (0), (0), (0), (0), (0), - cos(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - sin(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), (cos(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + sin(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu))), (0), (0), (0); (0), (0), (0), (bz - mz)*(cos(pitch_imu)*sin(roll_imu) - (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) + (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu)) - (by - my)*(cos(pitch_imu)*cos(roll_imu) + (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu) - (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu)), - (bz - mz)*(cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)) - cos(roll_imu)*sin(pitch_imu) - sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + cos(roll_imu)*cos(yaw_imu)^2*sin(pitch_imu) + cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)^2 + (cos(yaw_imu)*sin(pitch_imu)^2*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu)^2 - (sin(pitch_imu)^2*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu)^2) - (by - my)*(sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)) - sin(pitch_imu)*sin(roll_imu) + cos(yaw_imu)^2*sin(pitch_imu)*sin(roll_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)^2 - (cos(yaw_imu)*sin(pitch_imu)^2*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu)^2 + (sin(pitch_imu)^2*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu)^2) - (bx - mx)*(cos(pitch_imu)*cos(yaw_imu)^2 + cos(pitch_imu)*sin(yaw_imu)^2 - cos(pitch_imu)), (0), (0), (0), (0), - sin(pitch_imu)*cos(yaw_imu)^2 - sin(pitch_imu)*sin(yaw_imu)^2 + sin(pitch_imu), (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) - cos(pitch_imu)*sin(roll_imu) - (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu), (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu) - cos(pitch_imu)*cos(roll_imu), (0), (0), (0); (0), (0), (0), (mya - ya)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)) + (mza - za)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), cos(pitch_imu)*cos(roll_imu)*cos(yaw_imu)*(mza - za) - cos(yaw_imu)*sin(pitch_imu)*(mxa - xa) + cos(pitch_imu)*cos(yaw_imu)*sin(roll_imu)*(mya - ya), (mza - za)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) - (mya - ya)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - cos(pitch_imu)*sin(yaw_imu)*(mxa - xa), (0), (0), (0), (0), (0), (0), -cos(pitch_imu)*cos(yaw_imu), (cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), - sin(roll_imu)*sin(yaw_imu) - cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu); (0), (0), (0), - (mya - ya)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) - (mza - za)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)), cos(pitch_imu)*cos(roll_imu)*sin(yaw_imu)*(mza - za) - sin(pitch_imu)*sin(yaw_imu)*(mxa - xa) + cos(pitch_imu)*sin(roll_imu)*sin(yaw_imu)*(mya - ya), (mza - za)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)) - (mya - ya)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)) + cos(pitch_imu)*cos(yaw_imu)*(mxa - xa), (0), (0), (0), (0), (0), (0), -cos(pitch_imu)*sin(yaw_imu), - cos(roll_imu)*cos(yaw_imu) - sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu), (cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)); (0), (0), (0), cos(pitch_imu)*cos(roll_imu)*(mya - ya) - cos(pitch_imu)*sin(roll_imu)*(mza - za), - cos(pitch_imu)*(mxa - xa) - cos(roll_imu)*sin(pitch_imu)*(mza - za) - sin(pitch_imu)*sin(roll_imu)*(mya - ya), (0), (0), (0), (0), (0), (0), (0), sin(pitch_imu), -cos(pitch_imu)*sin(roll_imu), -cos(pitch_imu)*cos(roll_imu); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0)];
F = eye(15,15) + dt* tA;
U = [(0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0); - cos(yaw_imu)^2 - sin(yaw_imu)^2, (cos(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) - (sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu), (sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), - cos(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)) - sin(yaw_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), cos(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)) + sin(yaw_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)), (0), (0), (0), (0), (0), (0), (0), (0), (0); - sin(pitch_imu)*cos(yaw_imu)^2 - sin(pitch_imu)*sin(yaw_imu)^2 + sin(pitch_imu), (cos(yaw_imu)*sin(pitch_imu)*(cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)))/cos(pitch_imu) - cos(pitch_imu)*sin(roll_imu) - (sin(pitch_imu)*sin(yaw_imu)*(cos(roll_imu)*cos(yaw_imu) + sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu)))/cos(pitch_imu), (sin(pitch_imu)*sin(yaw_imu)*(cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)))/cos(pitch_imu) - (cos(yaw_imu)*sin(pitch_imu)*(sin(roll_imu)*sin(yaw_imu) + cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu)))/cos(pitch_imu) - cos(pitch_imu)*cos(roll_imu), (0), (0), (0), (0), (0), (0), (0), (0), (0); (0), (0), (0), -cos(pitch_imu)*cos(yaw_imu), (cos(roll_imu)*sin(yaw_imu) - cos(yaw_imu)*sin(pitch_imu)*sin(roll_imu)), - sin(roll_imu)*sin(yaw_imu) - cos(roll_imu)*cos(yaw_imu)*sin(pitch_imu), (0), (0), (0), (0), (0), (0); (0), (0), (0), -cos(pitch_imu)*sin(yaw_imu), - cos(roll_imu)*cos(yaw_imu) - sin(pitch_imu)*sin(roll_imu)*sin(yaw_imu), (cos(yaw_imu)*sin(roll_imu) - cos(roll_imu)*sin(pitch_imu)*sin(yaw_imu)), (0), (0), (0), (0), (0), (0); (0), (0), (0), sin(pitch_imu), -cos(pitch_imu)*sin(roll_imu), -cos(pitch_imu)*cos(roll_imu), (0), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (1), (0), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (1), (0), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (1), (0), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (1), (0); (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (0), (1)];
V  = U;
Qd = diag([0.01 ,0.01 ,0.01 ,0.01 ,0.01 ,0.01 ,0.01 ,0.01 ,0.01 ,0.01 ,0.01 ,0.01 ]) * dt;

covarEst = F* covarPrev * (F)' + V* Qd * V';
end

