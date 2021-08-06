
%% Data extraction 

vidObj = VideoReader('.\ensayo_2.mp4');


%% manually extracted data

close all
n=1:10:500;
c=1;
clear vid var;

for k=n
  video=vidObj.read(k);

  img=video(500:750,700:800,3);
  imgForce=flip(flip(video(1150:1550,700:900,:)),2);

  subplot(1,2,1)
  imshow(img)
  hold on
  yline(0:5:250,"b","LineWidth",0.5)
  yline(0:10:250,"r","LineWidth",0.5)
  
  hold off
  subplot(1,2,2)
  imshow(imgForce)
  pause(0.01)
  
  frame=getframe(gcf) ;
  
  
  vid(:,:,:,c)=frame.cdata;
  c=c+1;
end


implay(vid)

