function pc_map
figure();
set_figure_defaults; 
grid off; 
axis off;
Z=rand(1)+rand(1)*i;
col=9;
m=4000;
cx = -1;
cy = -1;
lspan = 3;
x=linspace(cx-lspan,cx+lspan,m);
y=linspace(cy-lspan,cy+lspan,m);
[X,Y]=meshgrid(x,y);
C=X+i*Y;
for k=1:col;
Z=conj(Z).^(Z)+C;
W=exp(-abs(Z))./(exp(-abs(Z))+1)
%W=exp(cos(abs(Z))./(abs(Z)));
end
%W=sqrt(conj(W).*W);
pcolor((real(abs(W))));
shading interp
axis off;
flp_bool = 1;
c=hot(50);d=flip(c);
if flp_bool==0
    colormap([d;c;d]);
else
    colormap([c;d;c]);
end

end