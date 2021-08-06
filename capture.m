
%% Capture data

vidObj = VideoReader('.\ensayo_2.mp4');


%% CV meassure distance

close all

data= readtable('data.xlsx');

mm_pix=0.2852;                 % pixels to milimeters 
t=(data.Frame-7)/3 ;           % time [s]
F=data.F_g_ *9.81/1000;        % force [N]


y0=[55.0000   73.7692   96.3684  115.3636];   % initial markers position

A=5*0.6                       % probe transversal Area[mm^2]
L=(y0(4)-y0(1))*mm_pix;       % Lenght between the edge markers [mm]         




n=70:10:470;
c=1;
clear vid_cv var distance img

figure('units','normalized','outerposition',[0 0 1 1])
for k=n
  video=vidObj.read(k);
  
  img=video(500:750,700:800,1);     % segment of image being display
  img_cv=video(550:700,720:740,:);  % segment of image analized by computer vision
  BW = createMask(img_cv);
  BW=bwareafilt(BW,[0 40]);
  props= regionprops(BW);
  centroids = cat(1,props.Centroid);
  
  % order region properties from top to bottom 
  [~,id]=sort(centroids(:,2));
  props=props(id);
  centroids = cat(1,props.Centroid);
  
  x=centroids(1:4,1)+20;
  y=centroids(1:4,2)+50;
  
  
  distance(c,:)=(y-y0')*mm_pix;       % matrix of distance
  
  % plots
  subplot(1,2,1)  
    imshow(img)
    hold on
    h=plot(x,y.*eye(4),".","markerSize",20)

    h2=yline(y,"-","LineWidth",2)
    [h2(:).Color]=h(:).Color;
    hold off
  subplot(2,2,2)
    plot(t(1:c),distance)
    title("Elongación")
    ylabel("\Delta x[mm]")
    xlabel("time [s]")
    xlim([0,14])
    ylim([0,30])

  subplot(2,2,4)
    d=(distance(:,4)-distance(:,1));
    sigma=F/A;           % MPa
    e=100*d/L;          % porcentaje

    plot(e,sigma(1:c),"og","MarkerSize",3,"MarkerFaceColor","g")
    title("Esfuezo vs Deformación")
    ylabel(" \sigma [MPa]")
    xlabel(" \epsilon [%]")
    xlim([0,120])
    ylim([0,5])
  
  frame=getframe(gcf) ;   
  vid_cv(:,:,:,c)=frame.cdata;
  
  c=c+1;
end

%implay(vid_cv)

%% export video


Fps=3;
writerObj = VideoWriter('tensile_strength.mp4','MPEG-4');
writerObj.FrameRate = Fps;
% open the video writer
open(writerObj);
% write the frames to the video
writeVideo(writerObj,vid_cv)

close(writerObj)

