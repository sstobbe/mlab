function [y,m,str] = engunits(x)
% y = x * m 
% TODO

eng_units       = {'a','f','p','n', 'u','m','','k','M','G','T','P','E'};



exp = log10(x);

if isinf(exp), exp = 0; end

E = floor(exp/3)*3;
m = 10^(-E);
y = x*m;
idx = 7 + E/3;
str = eng_units{idx};

end

