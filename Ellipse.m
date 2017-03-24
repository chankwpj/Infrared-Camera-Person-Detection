  function [x y] = Ellipse(cx, cy, axx, axy, ang)
    theta = 0 : 0.0001 : 2*pi;
    x = axy/2 * cos(theta) * cos(ang) - axx/2 * sin(theta) * sin(ang) + cx;
    y = axx/2 * sin(theta) * cos(ang) + axy/2 * cos(theta) * sin(ang) + cy;
  end