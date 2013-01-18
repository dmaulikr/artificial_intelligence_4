clear;
close all;

time_axis = -300:0.001:300;

w = zeros(size(time_axis));

for i=1:size(w, 2)
    if time_axis(i) >=0 && time_axis(i) < 30
        w(i) = 1;
    else
        w(i) = 0;
    end
end

plot(time_axis, w, 'b-');
xlabel('time (ms)')
ylabel('w')
title('Window function')
axis([-300 300 0 1.1]);